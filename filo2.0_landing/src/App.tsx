import { useEffect, useMemo, useRef, useState } from "react"
import "./styles.css"

type Theme = "light" | "dark"
type PageKey = "home" | "learn" | "pricing" | "releases"
type PricingCycle = "monthly" | "yearly"
type ModalKey = "connection" | "trigger" | "mcp"
type UILocale = "en" | "zh-CN" | "zh-TW"

type LearnSection = {
  id: string
  title: string
  paragraphs: string[]
}

type ReleaseGroup = {
  platform: string
  entries: { version: string; date: string; href: string }[]
}

const storageKey = "filo-theme"
const languageOptions = ["English (US)", "中文简体", "中文繁體"] as const

const localeByLanguageOption: Record<(typeof languageOptions)[number], UILocale> = {
  "English (US)": "en",
  "中文简体": "zh-CN",
  "中文繁體": "zh-TW",
}

const localizedLanguageLabel: Record<UILocale, string> = {
  en: "EN",
  "zh-CN": "简",
  "zh-TW": "繁",
}

const modalContentByKey: Record<ModalKey, { title: string; subtitle: string }> = {
  connection: {
    title: "Connection",
    subtitle:
      "A Connection is how Filo links to the apps you already use. Think of it like giving Filo a key to your tools. Once connected, Filo can read information, take action, and work inside those apps on your behalf, whether that is sending an email in Gmail, updating a row in Google Sheets, or posting a message in Slack.||Setting up a Connection takes less than a minute. You authorize Filo once, and it handles everything from there. No technical knowledge required, no API keys to manage, no complicated setup. Just connect and go.||The more apps you connect, the more powerful Filo becomes. Connections are what allow Filo to work across your entire toolkit at once, pulling information from one place and acting on it in another, so nothing falls through the cracks.",
  },
  trigger: {
    title: "Trigger",
    subtitle:
      "A Trigger is the condition that tells Filo when to start working. Instead of you having to ask Filo every single time, a Trigger lets you define the moment Filo should spring into action. That could be a new email arriving in your inbox, a specific time of day, a new row added to a spreadsheet, or an event happening in another app you use.||Once a Trigger is set, Filo runs automatically in the background, even when you are away from your desk. It is the difference between having an assistant who waits to be asked, and one who already knows when to act. Your workflows keep moving whether you are in a meeting, on a flight, or asleep.||Triggers are also flexible. You can set one up for a simple recurring task, or chain multiple Triggers together for more complex workflows. Either way, you stay in control of when and how Filo works.",
  },
  mcp: {
    title: "MCP",
    subtitle:
      "MCP stands for Model Context Protocol, an open standard that allows AI agents like Filo to communicate with a wide range of tools and services built by developers around the world. It is the technical bridge that makes Filo extensible far beyond its built-in integrations. If a tool supports MCP, Filo can connect to it and work with it right away.||For most users, you will never need to think about MCP directly. It simply means that Filo's library of supported tools keeps growing over time, as more developers around the world build MCP-compatible services. The more the ecosystem grows, the more Filo can do for you.||MCP is also what makes Filo future-proof. As new tools and platforms emerge, they can plug straight into Filo without waiting for a custom integration to be built. It is an open, collaborative standard, which means Filo grows alongside the tools the world is building, not behind them.",
  },
}

const learnSections: LearnSection[] = [
  {
    id: "overview",
    title: "Overview",
    paragraphs: [
      "Filo is an AI agent that connects to your tools and gets work done for you. Instead of only answering questions like a chatbot, Filo takes action. It can send emails, update spreadsheets, create tickets, post messages, and handle multi-step workflows from start to finish.",
      "You work with Filo through conversation. Describe what you need, and Filo asks clarifying questions, connects to the right services, and executes the task. You can also set up automations so Filo runs on its own on a schedule, when a new email arrives, or when another event is triggered, even when you are offline.",
      "Filo integrates with thousands of apps out of the box, and if there is not a prebuilt integration, it can connect directly to HTTP APIs. It also runs on its own cloud computer, which means it can write code, process files, browse the web, and operate software that does not offer an API.",
      "Filo is built for founders, operators, and teams that want to automate meaningful work. It is especially effective for business processes that need to run reliably around the clock, like customer support triage, lead routing, reporting, and operational workflows.",
    ],
  },
  {
    id: "connection",
    title: "Connection",
    paragraphs: modalContentByKey.connection.subtitle.split("||"),
  },
  {
    id: "trigger",
    title: "Trigger",
    paragraphs: modalContentByKey.trigger.subtitle.split("||"),
  },
  {
    id: "mcp",
    title: "MCP",
    paragraphs: modalContentByKey.mcp.subtitle.split("||"),
  },
  {
    id: "text-email-messaging",
    title: "Text & Email Messaging",
    paragraphs: [
      "Filo handles text and email messaging as first-class actions. It can draft, send, refine, and route messages using the context it already understands from your inbox and connected tools.",
      "Teams can define tone, escalation rules, and approval boundaries so messages stay useful without becoming risky or noisy.",
    ],
  },
  {
    id: "file-processing",
    title: "File Processing",
    paragraphs: [
      "Filo can process attachments and linked files so actions can be generated directly from documents, spreadsheets, and shared assets.",
      "That includes extracting key details, summarizing large files, and using those outputs as context for the next action in a workflow.",
    ],
  },
  {
    id: "billing",
    title: "Billing",
    paragraphs: [
      "Billing is designed to stay simple. Plans scale by capability, automation volume, and AI usage, while keeping core inbox functionality lightweight.",
      "Teams can monitor seats, limits, and renewal state from one place without turning billing into another admin surface.",
    ],
  },
  {
    id: "terms-of-service",
    title: "Terms of Service",
    paragraphs: [
      "These terms govern your access to and use of Filo. By using the service, you agree to comply with the rules that keep the platform secure, lawful, and reliable for everyone.",
      "Filo may update the service, suspend abuse, and limit or terminate accounts that violate these terms. You remain responsible for the content you send and the actions you authorize through your connected tools.",
      "Use of third-party integrations is also subject to the terms of those providers. If you do not agree with the terms, do not use the service.",
    ],
  },
  {
    id: "privacy-policy",
    title: "Privacy Policy",
    paragraphs: [
      "Filo is designed to minimize data collection and only use information required to provide the product. We use your connected account data to perform the actions you ask Filo to do.",
      "We do not use unnecessary personal data to train the product against your expectations. Security controls, access restrictions, and deletion processes are part of the default system design.",
      "Where required, you can request access, correction, or deletion of your data in line with applicable privacy laws.",
    ],
  },
  {
    id: "data-protection",
    title: "Data Protection",
    paragraphs: [
      "Filo uses layered controls for data protection, including encrypted transport, secure storage, scoped credentials, and provider-level permission boundaries.",
      "Operational access is restricted, monitored, and designed around least privilege so connected systems do not become a blind spot.",
      "As new compliance work completes, those standards are reflected in our public documentation and internal controls.",
    ],
  },
  {
    id: "cookie-policy",
    title: "Cookie Policy",
    paragraphs: [
      "Filo uses limited cookies and similar technologies to support site functionality, security, analytics, and product improvement.",
      "Where applicable, you can control non-essential cookies through your browser settings or site-level preferences.",
      "We aim to keep tracking minimal and proportionate to the product experience.",
    ],
  },
  {
    id: "brand-kit",
    title: "Brand Kit",
    paragraphs: [
      "The brand kit defines logo usage, spacing, background rules, and color behavior so the brand remains consistent across product and marketing.",
      "It also establishes the tone of voice, typography, and icon behavior that keep Filo recognizable without becoming loud.",
    ],
  },
  {
    id: "blog",
    title: "Blog",
    paragraphs: [
      "The blog covers product updates, workflow playbooks, comparisons, and implementation notes for teams adopting Filo.",
      "It is where we explain what changed, why it matters, and how to use it without adding extra noise.",
    ],
  },
  {
    id: "faq",
    title: "FAQ",
    paragraphs: [
      "The FAQ covers common questions around setup, integrations, automation behavior, privacy, and usage limits.",
      "It is intended to help teams get unblocked quickly before support is needed.",
    ],
  },
]

const pricingPlans = [
  {
    name: "Free",
    monthlyPrice: "$0",
    yearlyPrice: "$0",
    cadence: "/month",
    cta: "Get Started",
    footnote: "Billed $0 yearly, now $0 yearly",
    lead: "Includes:",
    features: [
      "Essential email features",
      "Limited AI summaries per day",
      "Limited to-dos per day",
      "Create up to 3 Smart Labels",
      "Create up to 3 Writing Styles",
      "Basic AI models",
    ],
    tone: "free" as const,
  },
  {
    name: "Plus",
    monthlyPrice: "$10",
    yearlyPrice: "$7",
    cadence: "/month",
    cta: "Start 30-Day Free Trial",
    footnote: "Billed $120 yearly, now $84 yearly",
    lead: "Everything in Free and:",
    features: [
      "More daily summaries and to-dos",
      "Thinking Mode for deeper replies",
      "Create up to 20 Smart Labels",
      "Create more Writing Styles",
      "Advanced AI models",
      "VIP 1-on-1 dedicated support",
      "Plus access on desktop and mobile",
    ],
    tone: "plus" as const,
  },
]

const releaseGroups: ReleaseGroup[] = [
  {
    platform: "iOS",
    entries: [
      { version: "V1.4.4", date: "Mar 31, 2026", href: "https://www.filomail.com/releases" },
      { version: "V1.4.3", date: "Mar 20, 2026", href: "https://www.filomail.com/releases" },
      { version: "V1.4.2", date: "Mar 7, 2026", href: "https://www.filomail.com/releases" },
      { version: "V1.4.1", date: "Feb 19, 2026", href: "https://www.filomail.com/releases" },
      { version: "V1.4.0", date: "Feb 2, 2026", href: "https://www.filomail.com/releases" },
    ],
  },
  {
    platform: "Desktop",
    entries: [
      { version: "V0.9.8", date: "Apr 2, 2026", href: "https://www.filomail.com/releases" },
      { version: "V0.9.7", date: "Mar 24, 2026", href: "https://www.filomail.com/releases" },
      { version: "V0.9.6", date: "Mar 14, 2026", href: "https://www.filomail.com/releases" },
      { version: "V0.9.5", date: "Feb 28, 2026", href: "https://www.filomail.com/releases" },
      { version: "V0.9.4", date: "Feb 12, 2026", href: "https://www.filomail.com/releases" },
    ],
  },
  {
    platform: "Android",
    entries: [
      { version: "V1.2.6", date: "Apr 1, 2026", href: "https://www.filomail.com/releases" },
      { version: "V1.2.5", date: "Mar 18, 2026", href: "https://www.filomail.com/releases" },
      { version: "V1.2.4", date: "Mar 4, 2026", href: "https://www.filomail.com/releases" },
      { version: "V1.2.3", date: "Feb 21, 2026", href: "https://www.filomail.com/releases" },
      { version: "V1.2.2", date: "Feb 8, 2026", href: "https://www.filomail.com/releases" },
    ],
  },
]

const rotatingAppIcons = [
  { name: "Gmail", src: "https://play-lh.googleusercontent.com/KSuaRLiI_FlDP8cM4MzJ23ml3og5Hxb9AapaGTMZ2GgR103mvJ3AAnoOFz1yheeQBBI=w480-h960-rw" },
  { name: "Google Drive", src: "https://play-lh.googleusercontent.com/t-juVwXA8lDAk8uQ2L6d6K83jpgQoqmK1icB_l9yvhIAQ2QT_1XbRwg5IpY08906qEw" },
  { name: "Google Calendar", src: "https://play-lh.googleusercontent.com/_bh6XK3B7TAk7kBXC1GHC0j9eS9cw9wQo2K7fiP7FDGAQlcOqgUPT2lx3WgZ0JlOJh8" },
  { name: "Outlook", src: "https://play-lh.googleusercontent.com/c97GpMazNS28iQcr5x3fsx1YQurED_BWwOtCowl9XqfYSu8xyRJXIpcB6E_yX06a7nQS=w480-h960-rw" },
  { name: "GitHub", src: "https://play-lh.googleusercontent.com/PCpXdqvUWfCW1mXhH1Y_98yBpgsWxuTSTofy3NGMo9yBTATDyzVkqU580bfSln50bFU=s96-rw" },
  { name: "Notion", src: "https://play-lh.googleusercontent.com/vaxxIC1qaXOd1q1hmL7c66N-Mp4LXuQIuBZGM0dPIbwmyWcJAXbhIIZ8hNBWvar54c_j=w480-h960-rw" },
  { name: "Jira", src: "https://play-lh.googleusercontent.com/2xGrEIF3DgB2-ijK7GzH7Fz8BVsW_d-z6sn8-UeMmYbpIhJPFn07o6YRjXON3-7SmQ=w480-h960-rw" },
  { name: "Slack", src: "https://play-lh.googleusercontent.com/mzJpTCsTW_FuR6YqOPaLHrSEVCSJuXzCljdxnCKhVZMcu6EESZBQTCHxMh8slVtnKqo" },
  { name: "Telegram", src: "https://play-lh.googleusercontent.com/ZU9cSsyIJZo6Oy7HTHiEPwZg0m2Crep-d5ZrfajqtsH-qgUXSqKpNA2FpPDTn-7qA5Q" },
  { name: "X", src: "https://play-lh.googleusercontent.com/A-Rnrh0J7iKmABskTonqFAANRLGTGUg_nuE4PEMYwJavL3nPt5uWsU2WO_DSgV_mOOM=w480-h960-rw" },
  { name: "Medium", src: "https://play-lh.googleusercontent.com/5uMPvygGoe3Y6aLKjdH1bxf567RA2mvY6dIsGocU5LQIyb8YjWkkuQt-m99ITIAwGWsi" },
  { name: "Spotify", src: "https://play-lh.googleusercontent.com/7ynvVIRdhJNAngCg_GI7i8TtH8BqkJYmffeUHsG-mJOdzt1XLvGmbsKuc5Q1SInBjDKN" },
]

function getSystemTheme(): Theme {
  return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light"
}

function getPageFromPath(pathname: string): PageKey {
  if (pathname.startsWith("/learn")) return "learn"
  if (pathname.startsWith("/pricing")) return "pricing"
  if (pathname.startsWith("/releases")) return "releases"
  return "home"
}

function ThemeToggle(props: { theme: Theme; onToggle: () => void }) {
  return (
    <button type="button" className="theme-toggle" onClick={props.onToggle} aria-label="Toggle theme">
      {props.theme === "light" ? (
        <svg viewBox="0 0 24 24" aria-hidden="true">
          <path d="M20.5 14.5A8.5 8.5 0 0 1 9.5 3.5a7 7 0 1 0 11 11Z" />
        </svg>
      ) : (
        <svg viewBox="0 0 24 24" aria-hidden="true">
          <circle cx="12" cy="12" r="4" />
          <path d="M12 2v3M12 19v3M4.93 4.93l2.12 2.12M16.95 16.95l2.12 2.12M2 12h3M19 12h3M4.93 19.07l2.12-2.12M16.95 7.05l2.12-2.12" />
        </svg>
      )}
    </button>
  )
}

export default function App() {
  const [theme, setTheme] = useState<Theme>("light")
  const [page, setPage] = useState<PageKey>("home")
  const [pricingCycle, setPricingCycle] = useState<PricingCycle>("yearly")
  const [selectedLanguage, setSelectedLanguage] = useState<(typeof languageOptions)[number]>("English (US)")
  const [languageOpen, setLanguageOpen] = useState(false)
  const [selectedLearnSectionId, setSelectedLearnSectionId] = useState("overview")
  const [modalOpen, setModalOpen] = useState(false)
  const [currentModalKey, setCurrentModalKey] = useState<ModalKey>("connection")
  const [visibleCard, setVisibleCard] = useState<0 | 1>(0)
  const [cardIndices, setCardIndices] = useState<[number, number]>([0, 1])
  const nextIconRef = useRef(2)
  const visibleRef = useRef<0 | 1>(0)
  const languagePickerRef = useRef<HTMLDivElement | null>(null)

  useEffect(() => {
    const initialTheme = (localStorage.getItem(storageKey) as Theme | null) || getSystemTheme()
    setTheme(initialTheme)
    setPage(getPageFromPath(window.location.pathname))
  }, [])

  useEffect(() => {
    document.documentElement.setAttribute("data-theme", theme)
    localStorage.setItem(storageKey, theme)
  }, [theme])

  useEffect(() => {
    document.body.classList.toggle("page-home", page === "home")
    document.body.classList.toggle("page-learn", page === "learn")
    document.body.classList.toggle("page-pricing", page === "pricing")
    document.body.classList.toggle("page-releases", page === "releases")
    return () => {
      document.body.classList.remove("page-home", "page-learn", "page-pricing", "page-releases")
    }
  }, [page])

  useEffect(() => {
    const onPopState = () => setPage(getPageFromPath(window.location.pathname))
    window.addEventListener("popstate", onPopState)
    return () => window.removeEventListener("popstate", onPopState)
  }, [])

  useEffect(() => {
    const onPointerDown = (event: MouseEvent) => {
      if (!languagePickerRef.current?.contains(event.target as Node)) setLanguageOpen(false)
    }
    window.addEventListener("mousedown", onPointerDown)
    return () => window.removeEventListener("mousedown", onPointerDown)
  }, [])

  useEffect(() => {
    if (page !== "home") return
    const timer = window.setInterval(() => {
      const incoming = visibleRef.current === 0 ? 1 : 0
      setCardIndices((previous) => {
        const next: [number, number] = [previous[0], previous[1]]
        next[incoming] = nextIconRef.current
        return next
      })
      setVisibleCard(incoming)
      visibleRef.current = incoming
      nextIconRef.current = (nextIconRef.current + 1) % rotatingAppIcons.length
    }, 1200)
    return () => window.clearInterval(timer)
  }, [page])

  useEffect(() => {
    document.body.classList.toggle("modal-open", modalOpen)
    return () => document.body.classList.remove("modal-open")
  }, [modalOpen])

  const currentModal = modalContentByKey[currentModalKey]
  const modalParagraphs = currentModal.subtitle.split("||")
  const selectedLearnSection = learnSections.find((section) => section.id === selectedLearnSectionId) ?? learnSections[0]
  const uiLocale = localeByLanguageOption[selectedLanguage]
  const activeAppName = rotatingAppIcons[cardIndices[visibleCard]]?.name ?? ""
  const isDarkChipFill = ["GitHub", "X", "Medium", "Spotify"].includes(activeAppName)
  const logoSrc = theme === "dark" ? "/assets/default-horizontal-dark.svg" : "/assets/default-horizontal.svg"

  const navigatePage = (nextPage: PageKey) => {
    const nextPath = nextPage === "home" ? "/" : `/${nextPage}`
    if (window.location.pathname !== nextPath) window.history.pushState({}, "", nextPath)
    setPage(nextPage)
    window.scrollTo({ top: 0, behavior: "instant" as ScrollBehavior })
  }

  const legalIds = new Set(["terms-of-service", "privacy-policy", "data-protection", "cookie-policy"])
  const contentTitle = useMemo(() => {
    if (page === "learn") return selectedLearnSection.title
    if (page === "pricing") return "Choose the plan that automates\nyour business with AI"
    return "Release Notes"
  }, [page, selectedLearnSection.title])

  return (
    <>
      <header className="topbar">
        <div className="header-left">
          <a
            className="brand"
            href="/"
            onClick={(event) => {
              event.preventDefault()
              navigatePage("home")
            }}
          >
            <img src={logoSrc} alt="FiloMail" />
          </a>
          <nav className="nav" aria-label="Primary">
            <a href="/learn" className={page === "learn" ? "is-active" : ""} onClick={(event) => { event.preventDefault(); navigatePage("learn") }}>Learn</a>
            <a href="/pricing" className={page === "pricing" ? "is-active" : ""} onClick={(event) => { event.preventDefault(); navigatePage("pricing") }}>Pricing</a>
            <a href="/releases" className={page === "releases" ? "is-active" : ""} onClick={(event) => { event.preventDefault(); navigatePage("releases") }}>Release Notes</a>
          </nav>
        </div>
        <div className="header-right">
          <div className="language-picker" ref={languagePickerRef}>
            <button type="button" className="language-trigger" onClick={() => setLanguageOpen((open) => !open)}>
              {localizedLanguageLabel[uiLocale]}
            </button>
            {languageOpen ? (
              <div className="language-menu" role="listbox" aria-label="Language">
                {languageOptions.map((option) => (
                  <button
                    key={option}
                    type="button"
                    className={"language-option" + (selectedLanguage === option ? " is-active" : "")}
                    onClick={() => {
                      setSelectedLanguage(option)
                      setLanguageOpen(false)
                    }}
                  >
                    {option}
                  </button>
                ))}
              </div>
            ) : null}
          </div>
          <ThemeToggle theme={theme} onToggle={() => setTheme((current) => (current === "light" ? "dark" : "light"))} />
        </div>
      </header>

      {page === "home" ? (
        <main>
          <section className="hero">
            <div className="hero-right-pane" aria-hidden="true" />
            <div className="hero-copy">
              <div className="hero-main-stack">
                <h1 className="hero-title">
                  <span className="hero-title-line">Your inbox</span>
                  <span className="hero-title-row">
                    <span>together with</span>
                    <span className={"app-chip" + (isDarkChipFill ? " is-dark-fill" : "")}>
                      <span className="app-chip-stack" aria-label="App integrations">
                        <img className={"app-card app-card-fade" + (visibleCard === 0 ? " is-visible" : "")} src={rotatingAppIcons[cardIndices[0]].src} alt={rotatingAppIcons[cardIndices[0]].name} />
                        <img className={"app-card app-card-fade" + (visibleCard === 1 ? " is-visible" : "")} src={rotatingAppIcons[cardIndices[1]].src} alt={rotatingAppIcons[cardIndices[1]].name} />
                      </span>
                    </span>
                  </span>
                  <span className="hero-title-line">gets things done.</span>
                </h1>
                <p className="hero-support">
                  Integrating 20+ popular apps, via{" "}
                  <a className="hero-inline-link" href="#" onClick={(event) => { event.preventDefault(); setCurrentModalKey("connection"); setModalOpen(true) }}>Connection</a>,{" "}
                  <a className="hero-inline-link" href="#" onClick={(event) => { event.preventDefault(); setCurrentModalKey("trigger"); setModalOpen(true) }}>Trigger</a>, and{" "}
                  <a className="hero-inline-link" href="#" onClick={(event) => { event.preventDefault(); setCurrentModalKey("mcp"); setModalOpen(true) }}>MCP</a>.
                </p>
                <div className="platform-links" aria-label="Platform downloads">
                  <a href="https://apps.apple.com/us/app/filomail-ai-gmail-client/id6740307388" target="_blank" rel="noreferrer">iOS</a>
                  <a href="https://play.google.com/store/apps/details?id=com.filo.client" target="_blank" rel="noreferrer">Android</a>
                  <a href="#" aria-disabled="true" title="Not available yet">macOS</a>
                  <a href="#" aria-disabled="true" title="Not available yet">Windows</a>
                </div>
              </div>
              <p className="hero-footnote">
                <a className="hero-footnote-link" href="https://appdefensealliance.dev/casa" target="_blank" rel="noreferrer">CASA Tier 2</a> certified, SOC 2 and GDPR compliance in progress.
              </p>
            </div>
          </section>
        </main>
      ) : page === "learn" ? (
        <main className="learn-main">
          <div className="learn-shell">
            <aside className="learn-sidebar" aria-label="Learn sections">
              <nav>
                {learnSections.map((section) => (
                  <button
                    key={section.id}
                    type="button"
                    className={"learn-sidebar-link" + (selectedLearnSectionId === section.id ? " is-active" : "")}
                    onClick={() => setSelectedLearnSectionId(section.id)}
                  >
                    {section.title}
                  </button>
                ))}
              </nav>
              <div className="learn-sidebar-bottom">
                <div className="learn-sidebar-socials">
                  <a href="https://discord.com/invite/filo-mail" target="_blank" rel="noreferrer" className="learn-sidebar-icon learn-sidebar-icon-discord" aria-label="Discord" />
                  <a href="https://x.com/Filo_Mail" target="_blank" rel="noreferrer" className="learn-sidebar-icon learn-sidebar-icon-x" aria-label="X" />
                </div>
                <p>© 2026 Filo AI</p>
              </div>
            </aside>
            <section className="learn-content">
              <article className={"learn-section" + (legalIds.has(selectedLearnSection.id) ? " is-legal" : "")}>
                <h2>{contentTitle}</h2>
                <div className="learn-paragraphs">
                  {selectedLearnSection.paragraphs.map((paragraph) => (
                    <p key={paragraph}>{paragraph}</p>
                  ))}
                </div>
              </article>
            </section>
          </div>
        </main>
      ) : page === "pricing" ? (
        <main className="pricing-main">
          <section className="pricing-shell">
            <div className="pricing-heading">
              <h1>{contentTitle}</h1>
              <div className="pricing-billing-note">
                <button type="button" className={pricingCycle === "monthly" ? "is-active" : ""} onClick={() => setPricingCycle("monthly")}>Monthly</button>
                <button type="button" className={pricingCycle === "yearly" ? "is-active" : ""} onClick={() => setPricingCycle("yearly")}>Yearly</button>
              </div>
            </div>
            <div className="pricing-plan-grid">
              {pricingPlans.map((plan) => (
                <article key={plan.name} className={"pricing-plan-card pricing-plan-card-" + plan.tone}>
                  <div className="pricing-plan-name-row">
                    <h3>{plan.name}</h3>
                  </div>
                  <div className="pricing-plan-price">
                    <strong>{pricingCycle === "monthly" ? plan.monthlyPrice : plan.yearlyPrice}</strong>
                    <span>{plan.cadence}</span>
                  </div>
                  <p className={"pricing-plan-footnote" + (plan.tone === "free" && pricingCycle === "monthly" ? " is-hidden" : "")}>
                    {pricingCycle === "yearly" || plan.tone === "free" ? plan.footnote : "Billed monthly"}
                  </p>
                  <a href="#" className={"pricing-plan-cta pricing-plan-cta-" + plan.tone}>{plan.cta}</a>
                  <div className="pricing-plan-features">
                    <p>{plan.lead}</p>
                    <ul>
                      {plan.features.map((feature) => (
                        <li key={feature}>{feature}</li>
                      ))}
                    </ul>
                  </div>
                </article>
              ))}
            </div>
            <p className="hero-footnote pricing-footnote">
              For more information or custom enterprise pricing, please contact
              <br />
              <span className="pricing-footnote-email">support@filomail.com</span>.
            </p>
          </section>
        </main>
      ) : (
        <main className="releases-main">
          <section className="releases-shell">
            <h1 className="releases-title">{contentTitle}</h1>
            <div className="releases-sections">
              {releaseGroups.map((group) => (
                <section className="release-platform" key={group.platform}>
                  <h3>{group.platform}</h3>
                  <div className="release-table-wrap">
                    <table className="release-table">
                      <thead>
                        <tr>
                          <th>Version</th>
                          <th>Date</th>
                        </tr>
                      </thead>
                      <tbody>
                        {group.entries.map((entry) => (
                          <tr key={`${group.platform}-${entry.version}-${entry.date}`}>
                            <td><a href={entry.href} target="_blank" rel="noreferrer">{entry.version}</a></td>
                            <td><a href={entry.href} target="_blank" rel="noreferrer">{entry.date}</a></td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </section>
              ))}
            </div>
          </section>
        </main>
      )}

      <div className={"modal-backdrop" + (modalOpen ? " is-open" : "")} onClick={(event) => { if (event.target === event.currentTarget) setModalOpen(false) }}>
        <div className="modal-card" role="dialog" aria-modal="true" aria-labelledby="modal-title">
          <button type="button" className="modal-close" aria-label="Close" onClick={() => setModalOpen(false)}>
            <svg viewBox="0 0 24 24" aria-hidden="true">
              <path d="M6 6L18 18M18 6L6 18" />
            </svg>
          </button>
          <div className="modal-content">
            <div key={currentModalKey} className="modal-content-frame">
              <h2 id="modal-title">{currentModal.title}</h2>
              <p>
                {modalParagraphs.map((paragraph, index) => (
                  <span key={`${currentModalKey}-${index}`}>
                    {paragraph}
                    {index < modalParagraphs.length - 1 ? <><br /><br /></> : null}
                  </span>
                ))}
              </p>
            </div>
          </div>
          <nav className="modal-nav" aria-label="Modal sections">
            <button className={"modal-nav-item" + (currentModalKey === "connection" ? " is-active" : "")} type="button" onClick={() => setCurrentModalKey("connection")}>Connection</button>
            <button className={"modal-nav-item" + (currentModalKey === "trigger" ? " is-active" : "")} type="button" onClick={() => setCurrentModalKey("trigger")}>Trigger</button>
            <button className={"modal-nav-item" + (currentModalKey === "mcp" ? " is-active" : "")} type="button" onClick={() => setCurrentModalKey("mcp")}>MCP</button>
          </nav>
        </div>
      </div>
    </>
  )
}
