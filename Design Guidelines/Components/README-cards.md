# Filo Card Components

Cards are contextual UI containers that surface AI-powered insights and actions directly within the email experience. They help users understand, act on, and manage their emails efficiently.

## Summary Cards

Filo's signature feature — AI-generated email summaries that appear at the top of each message.

### What Makes Filo Summaries Different

Unlike other email clients, Filo summaries are:
- **Auto-loaded** — No need to click; summaries appear instantly
- **Short & precise** — Usually 1-2 sentences or a tight bullet list
- **Action-oriented** — Highlights what you need to do, not just what the email says
- **Multilingual** — Summarizes in your preferred language (configurable in Settings)

### Key Features

| Feature | Description |
|---------|-------------|
| **Language Preference** | Summaries adapt to your chosen language — perfect for emails in unfamiliar languages |
| **Embedded Actions** | If the email has buttons (e.g., "Check in", "RSVP"), they appear in the summary |
| **Feedback Icons** | Thumbs up/down on the top-right corner helps improve AI quality |
| **Usage Limits** | Free daily quota; when exceeded, tap "Summarize this email" to generate manually |

### Variants

| Card | State | When Used |
|------|-------|-----------|
| `summary-ghost` | Collapsed | Summary not yet generated or manual mode |
| `summary-ghost-caption` | Collapsed + message | Daily limit reached, shows upgrade option |
| `summary-generating` | Loading | AI is processing the email |
| `summary-default` | Full summary | Normal display with bullet points and actions |

---

## Todo Cards

Auto-converts actionable emails into clear, structured tasks so nothing slips through the cracks.

### How It Works

When Filo detects an email requiring action, it extracts the key information and creates a todo card with:
- **Task description** — Clear, concise summary of what needs to be done
- **Checkbox** — Mark as complete when done
- **Tag** — Status indicator (To respond, Awaiting Reply, Meeting Update, Suggested Done)
- **Time** — Due date or relevant timestamp
- **More menu** — View details, report incorrect todo, delete

### Statuses

| Status | Meaning |
|--------|---------|
| **To respond** | Email requires your reply |
| **Awaiting Reply** | You've responded; waiting for their reply |
| **Meeting Update** | Calendar or meeting-related action |
| **Suggested Done** | AI thinks this might be complete |

---

## Tracker Cards

Exposes invisible email trackers that senders use to monitor open rates and engagement.

### Why It Matters

Most promotional emails embed invisible tracking pixels. Filo:
- **Detects** these trackers automatically
- **Blocks** them from reporting back to senders
- **Shows** you exactly which domains were blocked

### Variants

| Card | Description |
|------|-------------|
| `tracker-collapsed` | Compact pill showing "Blocked X tracker(s)" |
| `tracker-expanded` | Full list of blocked tracker domains + Learn More |

---

## AI Action Cards

When Filo AI performs specific tasks, results are presented in focused card formats for easy review and confirmation.

### Types

| Card | Purpose | Actions |
|------|---------|---------|
| `ai-draft` | AI-composed email reply | Edit in Draft, Send Now |
| `ai-label` | Smart label suggestion | Edit, Confirm & Create |
| `ai-filter` | Email filter rule | Edit, Confirm & Save |
| `ai-todo` | Extracted task item | Edit, Confirm |
| `ai-select` | Batch selection list | Delete X |

---

## Tips Card

System notifications and helpful guidance for users.

### Use Cases

- Account disconnection alerts
- Feature onboarding tips
- Status updates
- Dismissible with close button

---

## Spam/Risk Card

Security warning when Filo detects potentially dangerous emails.

### Triggers

- Phishing characteristics detected
- Scam patterns identified
- Suspicious attachments
- User can report false positives with "Report not spam"

---

## Design Specifications

### Backgrounds

| Type | Color | Usage |
|------|-------|-------|
| Blue | `--filo-05` | Summary, Todo (positive/informational) |
| Gray | `--filo-14` | AI actions, Tips, Spam, Trackers (neutral/warning) |

### Dimensions

- **Width:** 350px (standard)
- **Border radius:** 24px (standard), 999px (pill)
- **Padding:** 16px (standard), 10px (compact)

### Typography

- **Title:** P1_B (19px, Bold)
- **Body:** P1.1_R (17px, Regular)
- **Caption:** P3.1_M (14px, Medium)
- **Tag:** P4_B (13px, Bold)

---

## Reference

For more details on Filo's AI features, see the [official documentation](https://filo-mail.gitbook.io/filo-mail-docs/core-features/ai-summary).
