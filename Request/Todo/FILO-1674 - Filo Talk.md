# FILO-1674 — Filo Talk

> Filo AI 支持语音

| Field | Value |
|-------|-------|
| Jira | FILO-1674 |
| Platform | macOS, iOS |
| Filo Feature | Filo Talk |
| Related | FILO-1647 (Redesign AI Tab) — this feature supersedes the AI Tab idle state |


---

## What This Is

Filo Talk is a voice-driven AI conversation inside Filo's AI Tab. The user speaks, Filo acts on their email (search, archive, compose, reply, create tasks, set rules), and responds with voice + text. The conversation is continuous — no re-tapping, no re-prompting — until the user decides they're done.

---

## Why This Matters

### The user problem

Email power users — the people Filo is built for — don't have time to type. They're between meetings, commuting, cooking, walking. They glance at their phone and think: *"Did John reply? Archive that newsletter. Tell Sarah I'll be late."* Right now, each of those requires opening the app, finding the email, tapping through menus. Three thoughts, nine taps, two minutes of attention.

Voice collapses that to one interaction. The user says what they want, Filo does it. The cognitive load drops from "navigate → find → decide → act" to just "decide → speak."

### The market context

Voice AI assistants in email are still rare and mostly bad. Siri can read your last email but can't act on it. Google Assistant can compose but can't triage. The few email apps with voice (Spark, Edison) treat it as a novelty — dictation for compose, nothing more.

The opportunity is a voice-driven email assistant that actually understands email workflows: multi-step actions, context-aware replies, batch operations. No one has nailed this yet.

### The design challenge

Voice AI is inherently "AI as spectacle" — the whole feature is about talking to AI. This directly conflicts with Filo's principle of "AI as infrastructure, not spectacle." The design must resolve this tension:

- **The conversation is the product, not the chrome.** Minimize visible UI during active voice. Let the words and actions carry the experience.
- **Animations communicate state, not entertain.** Volume-reactive gradients should tell the user "I'm listening" — not perform a light show.
- **One good default for everything.** One voice, one animation style, one interaction model. No settings screen masquerading as a feature.

---

## Relationship to FILO-1647

FILO-1647 (Redesign AI Tab) defined the AI Tab's structure: Needs Attention, Handled, Insights. This ticket introduces voice as the primary interaction mode for the same tab.

**Design decision:** Filo Talk's Idle state IS the new AI Tab. FILO-1674 supersedes FILO-1647's Idle layout. The AI Tab now has two modes:
1. **Conversation mode** (default) — chat history, text input, quick commands, mic button
2. **Voice mode** — triggered by tapping mic, full-screen listening/processing UI

The "Needs Attention" / "Handled" sections from FILO-1647 can surface as quick command suggestions or proactive AI messages in the conversation history.

---

## Entry Points

| Entry | Gesture | Result |
|-------|---------|--------|
| AI Tab | Tap tab bar icon | Opens AI Tab → Idle state |
| Mic button | Tap mic in Idle input bar | Enters Listening state |
| Quick command | Tap command bubble in Idle | Sends command as text, AI processes |

---

## Exit Points

| Exit | Gesture | Result |
|------|---------|--------|
| Stop button | Tap Stop during Listening/Processing | Returns to Idle with conversation preserved |
| Tab switch | Tap another tab bar icon | Leaves AI Tab, voice session ends |
| App background | Press home / switch app | Voice session pauses, resumes on return |
| Silence timeout | No speech detected for 10s during Listening | Auto-returns to Idle with gentle prompt |
| Navigate away | AI action opens compose/inbox | Voice pauses, returns on back navigation |

---

## User Flows

### Flow 1: First-Time User (Cold Start)

```
User taps AI Tab
    │
    ▼
┌─ Has microphone permission? ─────────────────────┐
│                                                    │
│  NO                                           YES  │
│  ▼                                             ▼   │
│  Show permission primer screen              Skip   │
│  "Filo needs your microphone                  │    │
│   to listen to voice commands"                │    │
│  [Allow] [Not Now]                            │    │
│     │         │                               │    │
│     ▼         ▼                               │    │
│  iOS system   Idle state                      │    │
│  permission   (text-only mode,                │    │
│  dialog       mic button shows                │    │
│     │         permission hint                 │    │
│     │         on tap)                         │    │
│     ▼                                         │    │
│  Granted? ──NO──► Idle (text-only,            │    │
│     │              mic disabled with           │    │
│     │              "Enable in Settings" link)  │    │
│    YES                                        │    │
│     │                                         │    │
└─────┴─────────────────────────────────────────┘
      │
      ▼
┌─ Has seen onboarding? (`hasSeenAITutorial`) ──┐
│                                                │
│  NO                                       YES  │
│  ▼                                         ▼   │
│  Onboarding flow (see below)           Idle    │
│  → Completes → Idle                    state   │
│                                                │
└────────────────────────────────────────────────┘
```

### Flow 2: Onboarding (First-time only)

```
Step 1: AI greeting
  "Hi, I'm your Filo AI assistant."
  (Auto-plays as voice + text bubble)
      │
      ▼
Step 2: Capability showcase
  3 quick command bubbles appear with staggered animation:
  • "Archive read emails"
  • "Any new emails?"
  • "Write a new email"
  User can tap any to try, or skip
      │
      ▼
Step 3: Prompt to try voice
  "Try saying something"
  Mic button pulses gently
  User taps mic → enters Listening
      │
      ▼
Step 4: AI responds → completion
  "You can find me anytime in the AI tab."
  Mark `hasSeenAITutorial = true`
      │
      ▼
  → Normal Idle state
```

### Flow 3: Voice Conversation (Core Loop)

```
IDLE STATE
  Chat history + text input + quick commands
  Mic button at bottom-right of input bar
      │
      ├──── User taps mic ────────────────┐
      │                                    │
      ├──── User types text ──┐            │
      │                       ▼            ▼
      │                  Send as text   LISTENING STATE
      │                  AI processes   Waveform animation
      │                       │         Real-time transcription
      │                       │         Stop button visible
      │                       │            │
      │                       │            ├── User stops speaking (pause > 1.5s)
      │                       │            ├── User taps Stop
      │                       │            │
      │                       ▼            ▼
      │                  PROCESSING STATE
      │                  Thinking animation → streaming text + voice
      │                  Stop button (tap to interrupt)
      │                       │
      │                       ├── Simple response (text/voice reply)
      │                       │   → Message appears in chat
      │                       │   → AI continues listening (Live mode)
      │                       │
      │                       ├── Search ("find emails from John")
      │                       │   → "Searching..." indicator
      │                       │   → Results render as email cards (max 5 inline)
      │                       │   → "View all X results" if more
      │                       │   → AI summarizes vocally
      │                       │
      │                       ├── Compose / Reply ("reply saying I'll be late")
      │                       │   → AI confirms: "I'll draft that for you"
      │                       │   → Compose sheet slides up (half-sheet)
      │                       │   → Draft pre-filled, user reviews
      │                       │   → Send / Edit / Cancel
      │                       │   → Returns to voice conversation
      │                       │
      │                       ├── Batch action ("archive all read emails")
      │                       │   → AI confirms: "Archived 3 emails"
      │                       │   → Undo toast (3s)
      │                       │   → Continues listening
      │                       │
      │                       ├── Create task ("remind me tomorrow at 3pm")
      │                       │   → AI confirms: "Task created"
      │                       │   → Task card in chat
      │                       │   → Continues listening
      │                       │
      │                       └── Create rule ("auto-archive newsletters")
      │                           → AI confirms: "Rule created"
      │                           → Rule summary card in chat
      │                           → Continues listening
      │
      └──── User taps Stop / switches tab ──► IDLE STATE
             Conversation preserved in history
```

---

## Screen States

### State 1: Idle

The default resting state of the AI Tab. This is where conversation happens via text, and where the user launches voice mode.

**Layout (top to bottom):**
- **Navigation bar:** "AI" title, settings gear icon (voice preferences)
- **Conversation area:** Scrollable chat history (newest at bottom)
  - User messages: right-aligned, primary blue background (`#22A0FB`), white text
  - AI messages: left-aligned, surface background (`#F5F5F5` / `#2A2A30`), primary text
  - Tool result cards: full-width, subtle border, contextual content
  - Timestamps: grouped by day, centered, caption style (`P4_R`)
- **Quick commands:** Horizontal scroll of pill-shaped bubbles above the input bar. Only show when conversation is empty or at conversation start. Max 4 visible.
  - Style: surface secondary background (`#E8EEF2`), primary text, `P3_M`, corner radius `full`
- **Input bar:** Text field + mic button
  - Text field: standard input, placeholder "Type a message..." (`P2_R`, text tertiary)
  - Mic button: `microphone-circle` icon, primary blue, 44pt tap target
  - Send button: appears when text is entered, replaces mic button

**Empty state (no conversation history):**
- Centered Filo AI icon (use `ai-main` from icon library)
- Greeting text: "Hi, I'm your Filo AI assistant" (`P1_M`, text secondary)
- Subtext: "Ask me anything about your emails" (`P3_R`, text tertiary)
- Quick command bubbles displayed below the greeting (not above input bar)

### State 2: Listening

Full-screen takeover. The user is speaking, and Filo is transcribing in real-time.

**Layout:**
- **Background:** Subtle gradient animation at bottom third of screen. Colors derived from Filo primary palette — blues and soft purples (`#22A0FB`, `#7F6EFF` blend). Responds to microphone input amplitude:
  - Silence: small, muted, slow drift (opacity ~0.3)
  - Speaking: larger, brighter, rhythmic pulse (opacity ~0.6)
  - Keep it restrained — this should feel like breathing, not a visualizer
- **Transcription:** Live text appears center-screen, `P1_M`, text primary. Fades previous lines to text tertiary as new text arrives. Max 3 visible lines.
- **Status indicator:** "Listening..." label at top, `P4_R`, text tertiary
- **Stop button:** Bottom center, circular, 56pt, red background (`#E53935`), white stop icon. Clear tap target with 44pt minimum.
- **Transition from Idle:** Conversation area fades/scales down, listening UI fades in. Duration 300ms, ease-out.

### State 3: Processing

AI is thinking and/or executing a tool call. The UI shows progress without being noisy.

**Layout:**
- **Background:** Same gradient as Listening, but shifts to calm, rhythmic mode (no audio input)
- **Thinking indicator:** Animated dots or subtle pulse below transcribed text. "Thinking..." label, `P4_R`
- **Streaming response:** AI text streams in word-by-word below the thinking indicator. `P1.1_R`, text primary. Simultaneous voice playback.
- **Stop button:** Same position as Listening. Tap interrupts both text streaming and voice playback.
- **Tool execution:** When a tool is called, show a brief status line: "Searching your emails..." / "Drafting reply..." — `P3_R`, text secondary

### State 4: Compose/Reply Handoff

When the AI needs to compose or reply to an email, the compose view appears as a half-sheet overlay.

**Behavior:**
- Voice mode pauses (gradient animation freezes, no recording)
- Compose sheet slides up from bottom (standard iOS sheet, medium detent)
- Draft is pre-filled by AI. User can edit, then Send or Cancel.
- On dismiss, voice conversation resumes. AI confirms: "Email sent" or "Draft discarded"
- The conversation behind the sheet remains visible (dimmed)

### State 5: Search Results

When AI searches emails, results appear as cards in the conversation.

**Layout:**
- AI message bubble with summary text: "Found 8 emails from John"
- Below the bubble: vertically stacked email preview cards (max 5)
  - Each card: sender, subject, date, 1-line preview. Standard `EmailRow` component from design system, compact variant.
  - Tap a card → navigates to email detail (voice session pauses)
- If > 5 results: "View all 8 results →" link at bottom, navigates to filtered inbox view
- If 0 results: AI message: "No emails found matching that" — no empty state card needed, just the text response

---

## Error States

### E1: Microphone Permission Denied

**When:** User taps mic but has never granted or previously denied microphone access.

**First ask (before iOS system dialog):**
- Display a pre-permission screen within the AI Tab
- Illustration: `microphone` icon, large, text secondary color
- Title: "Voice needs microphone access" (`P1_B`)
- Body: "Filo listens to your voice commands to help manage email. Audio is processed in real-time and never stored." (`P2_R`, text secondary)
- Primary button: "Allow Microphone" → triggers iOS system permission dialog
- Secondary text link: "Not now" → dismisses, returns to Idle (text-only mode)

**Permanently denied (user denied in iOS Settings):**
- Mic button shows disabled state (text tertiary color)
- On tap: inline banner below input bar
  - "Microphone access is off. Enable it in Settings to use voice."
  - "Open Settings" link → opens `UIApplication.openSettingsURL`
  - Dismiss "×" button

### E2: Speech Recognition Permission Denied

**When:** Microphone is granted but SFSpeech recognition authorization is denied.

- Same pattern as E1 but with copy: "Speech recognition lets Filo understand what you say. Processing happens on-device when possible."
- If denied: voice recording works but transcription falls back to server-only (Whisper). Show "Transcribing..." instead of real-time text.

### E3: Network Error

**When:** Connection lost during voice conversation.

- Voice recording stops automatically
- Inline error message in conversation: "Connection lost. Your message wasn't sent." 
- Style: error background (`#FFE5E7` / `#461D21`), error text, `P3_R`
- "Retry" button below the message
- Mic button remains available — user can try again when connection restores

### E4: STT Failure / Low Confidence

**When:** Speech-to-text returns garbage or fails entirely.

- AI responds: "Sorry, I didn't catch that. Could you try again?"
- Displayed as a normal AI message bubble
- No special error UI — keep it conversational
- Auto-returns to Listening if in Live mode

### E5: Tool Call Failure

**When:** AI attempts an action (archive, send, search) and the backend fails.

- AI responds: "I couldn't archive those emails. Something went wrong on our end."
- Error message card in conversation with contextual action:
  - "Try again" button
  - Fallback suggestion: "You can do this manually from your inbox"
- Style: standard AI message, no red/alarm colors — keep it calm

### E6: Silence Timeout

**When:** User enters Listening state but doesn't speak for 10 seconds.

- Gentle prompt appears: "Still there?" (`P3_R`, text tertiary, centered)
- After 5 more seconds of silence: auto-return to Idle
- Transcription area shows nothing — no "..." or fake activity
- Transition: Listening UI fades out, Idle fades in (300ms)

### E7: AI Rate Limit / Quota Exceeded

**When:** User hits AI usage limits (free plan).

- AI responds: "You've reached your daily voice limit. Upgrade to Filo Plus for unlimited voice."
- Inline card with upgrade CTA (not aggressive — `P3_R`, text secondary, subtle primary button)
- Text input remains fully functional — only voice is limited
- Mic button shows disabled state with small "Plus" badge

---

## Empty States

### No Conversation History (First Visit)
See Idle empty state above — greeting + quick commands.

### No Search Results
AI text response only: "No emails found matching that." No special illustration or card.

### No Tasks Extracted
AI text response: "I didn't find any action items in that email." Conversational, not an error.

### AI Tab with No AI Features Active
This shouldn't happen post-MVP. But if it does: show the greeting state with quick commands suggesting first actions.

---

## Onboarding Flow (First-Time Only)

**Trigger:** `hasSeenAITutorial == false` AND microphone permission granted.

**Sequence:**
1. AI greeting message auto-appears with typing animation (no voice playback on step 1 — don't startle the user with unexpected audio)
2. Quick command bubbles animate in with staggered delay (100ms between each)
3. After 2s, prompt text: "Try saying something" with mic button pulse animation
4. User taps mic → normal Listening flow
5. After first successful exchange, closing message + mark tutorial complete

**If mic permission not granted:** Skip voice onboarding. Show text-only greeting: "Hi, I'm your Filo AI assistant. Type a message or enable voice in settings."

---

## Animation Direction

All animations must pass the "reduced motion" test: if `UIAccessibility.isReduceMotionEnabled`, replace animations with simple opacity fades.

### Background Gradient
- **Colors:** Primary blue (`#22A0FB`) + Purple (`#7F6EFF`), blended as soft gradient blobs
- **Dark mode:** Use dark variants (`#45B1FF` + `#7F6EFF`) at lower opacity
- **Behavior:** 2-3 organic shapes, gaussian blur (radius ~60px), positioned in bottom third
- **Idle:** Shapes invisible or barely visible (opacity 0.05)
- **Listening/silence:** Slow drift, small scale, opacity 0.15-0.25
- **Listening/speaking:** Scale up 1.2x-1.5x proportional to amplitude, opacity 0.3-0.5, movement speed increases
- **Processing:** Gentle rhythmic pulse at fixed tempo (~1Hz), opacity 0.2
- **Easing:** All transitions use `easeInOut`, duration 200-400ms
- **Performance:** Use `CADisplayLink` for smooth 60fps, Metal shader preferred for blur

### State Transitions
- Idle → Listening: 300ms, conversation area scales to 0.95 and fades to 0.3 opacity, listening UI fades in
- Listening → Processing: 200ms crossfade, gradient shifts to calm mode
- Processing → Idle: 300ms, streaming text scrolls into conversation history, gradient fades out
- All transitions: `UIView.animate` with `.curveEaseInOut`

### Micro-interactions
- Mic button tap: scale 0.9 → 1.0, 150ms spring animation
- Stop button tap: scale 0.9 → 1.0, haptic impact (light)
- Quick command tap: background darkens 10%, 100ms

---

## Voice Configuration

**Default voice:** `nova` (warm, clear, natural-sounding). No voice selection in MVP — opinionated default, per Filo principles.

**Post-MVP (settings):** If voice selection is added later, place it in Settings > AI > Voice. Not on the main voice screen — it's a preference, not a feature.

**Playback:** Streaming PCM, sentence-by-sentence. First audio chunk should play within 1s of AI response start. Concurrent with text streaming — text leads audio slightly.

---

## Accessibility

- **VoiceOver:** All interactive elements labeled. Listening state announces "Recording. Tap stop to end." Processing announces "Filo is thinking."
- **Reduced Motion:** Gradient animation replaced with static gradient at 0.15 opacity. State transitions use opacity-only fades (no scale/position).
- **Dynamic Type:** Transcription text and conversation bubbles respect system text size. Quick command pills wrap to next line at larger sizes.
- **Minimum tap targets:** 44pt for all interactive elements (per Apple HIG)

---

## Dark Mode

Every screen state needs both variants. Key mappings:

| Element | Light | Dark |
|---------|-------|------|
| Background | `#FFFFFF` | `#1D1D21` |
| User message bubble | `#22A0FB` | `#45B1FF` |
| AI message bubble | `#F5F5F5` | `#2A2A30` |
| Quick command pill | `#E8EEF2` | `#344352` |
| Transcription text | `#000000` | `#FFFFFF` |
| Gradient blob (primary) | `#22A0FB` @ 0.3 | `#45B1FF` @ 0.25 |
| Gradient blob (secondary) | `#7F6EFF` @ 0.2 | `#7F6EFF` @ 0.15 |
| Error banner | `#FFE5E7` | `#461D21` |
| Stop button | `#E53935` | `#BE424D` |

---

## Component Inventory (New)

Components that don't exist in `Design Guidelines/Components/` and need to be created:

| Component | Description |
|-----------|-------------|
| **VoiceInputBar** | Text input + mic button. Mic swaps to send when text is entered. |
| **QuickCommandPill** | Horizontal scroll pill with icon + text. Surface secondary bg, full radius. |
| **GradientBlob** | Animated organic shape with gaussian blur. Responds to audio amplitude. |
| **TranscriptionDisplay** | Center-screen streaming text with line fade. Max 3 lines visible. |
| **ToolResultCard** | Contextual card for search results, tasks, rules. Extends Card component. |
| **PermissionPrimer** | Pre-permission screen with icon, title, body, CTA. Reusable for mic + speech. |
| **ErrorBanner** | Inline conversation error with retry action. Error background + text. |
| **ComposeHalfSheet** | iOS sheet (medium detent) for compose/reply with pre-filled draft. |

---

## Icon Usage (from existing library)

| Use | Icon |
|-----|------|
| Mic button (Idle) | `microphone-circle` |
| Mic button (disabled) | `microphone-circle` + tertiary color |
| Stop (Listening/Processing) | `stop` |
| Send text | `send-message` |
| Settings | `settings` |
| AI avatar | `ai-main` |
| Close/dismiss | `close-minimal` |
| Error indicator | `error` |
| Volume/audio | `Volumn_High` / `Volumn_Off` |

---

## i18n Strings

### Core UI
| Key | EN | ZH |
|-----|----|----|
| ai_tab_title | AI | AI |
| ai_greeting | Hi, I'm your Filo AI assistant | 你好，我是 Filo AI 助手 |
| ai_greeting_sub | Ask me anything about your emails | 有关邮件的任何事，问我就好 |
| ai_listening | Listening... | 正在听... |
| ai_thinking | Thinking... | 思考中... |
| ai_stop | Stop | 停止 |
| ai_type_message | Type a message... | 输入消息... |

### Quick Commands
| Key | EN | ZH |
|-----|----|----|
| ai_quick_archive | Archive read emails | 归档已读邮件 |
| ai_quick_unread | Any new emails? | 有新邮件吗？ |
| ai_quick_compose | Write a new email | 写一封新邮件 |

### Onboarding
| Key | EN | ZH |
|-----|----|----|
| ai_tutorial_intro | I can help you manage emails and tasks by voice | 我可以通过语音帮你管理邮件和任务 |
| ai_tutorial_try | Try saying something | 试着说点什么 |
| ai_tutorial_done | You can find me anytime in the AI tab | 随时在 AI Tab 找到我 |

### Permissions
| Key | EN | ZH |
|-----|----|----|
| ai_mic_title | Voice needs microphone access | 语音功能需要麦克风权限 |
| ai_mic_body | Filo listens to your voice commands to help manage email. Audio is processed in real-time and never stored. | Filo 通过语音指令帮你管理邮件。音频实时处理，不会存储。 |
| ai_mic_allow | Allow Microphone | 允许麦克风 |
| ai_mic_not_now | Not now | 暂时不用 |
| ai_mic_denied | Microphone access is off. Enable it in Settings to use voice. | 麦克风权限已关闭。前往设置开启以使用语音功能。 |
| ai_mic_open_settings | Open Settings | 打开设置 |
| ai_speech_title | Enable speech recognition | 开启语音识别 |
| ai_speech_body | Speech recognition lets Filo understand what you say. Processing happens on-device when possible. | 语音识别让 Filo 理解你说的话。尽可能在设备本地处理。 |

### Errors
| Key | EN | ZH |
|-----|----|----|
| ai_error_network | Connection lost. Your message wasn't sent. | 连接中断，消息未发送。 |
| ai_error_retry | Try again | 重试 |
| ai_error_stt | Sorry, I didn't catch that. Could you try again? | 抱歉，没听清。能再说一次吗？ |
| ai_error_tool | Something went wrong. You can try again or do this manually. | 出了点问题。你可以重试或手动操作。 |
| ai_error_quota | You've reached your daily voice limit. | 你已达到今日语音使用上限。 |
| ai_silence_prompt | Still there? | 还在吗？ |

### Tool Feedback
| Key | EN | ZH |
|-----|----|----|
| ai_searching | Searching your emails... | 正在搜索邮件... |
| ai_drafting | Drafting reply... | 正在起草回复... |
| ai_archived | Archived {count} emails | 已归档 {count} 封邮件 |
| ai_task_created | Task created | 任务已创建 |
| ai_rule_created | Rule created | 规则已创建 |
| ai_view_all | View all {count} results | 查看全部 {count} 条结果 |

---

## Competitive Reference

### Voice AI Conversation

| Product | What they do well | What they get wrong | What we steal |
|---------|-------------------|---------------------|---------------|
| **Claude Voice** | Tone feels like a thoughtful colleague, not a performer. Text + voice concurrency is clean — text leads, voice follows. Doesn't try to be charming. | Newer, less polished on interruption handling. | **Tonal north star for Filo.** Calm, restrained, non-spectacle. The dual-channel text+voice approach for Processing state. |
| **ChatGPT Voice Mode** | Interruption handling is best in class — you cut in and it adapts naturally. Streaming feels alive. Conversation is genuinely continuous. | The orb animation demands attention. No integration with anything outside the app. | **Interaction mechanics.** Interruption model, streaming concurrency, the feeling that the AI is "present." |
| **Google Gemini Live** | Multi-turn conversation with tool execution. Shows what's possible when voice AI can actually do things. | UI is cluttered. Too many visual elements competing. | Voice + action execution concept. Keep the execution feedback but dramatically simplify the chrome. |
| **Apple Siri (iOS 18)** | Ambient glow at screen edge — most restrained voice indicator in the market. Feels native to iOS. | Can't do anything useful with email. No multi-turn. | Glow-as-state-indicator. The ceiling for "how little visual feedback can you get away with." |

### AI in Email

| Product | What they do well | What they get wrong | What we steal |
|---------|-------------------|---------------------|---------------|
| **Shortwave** | AI-first email client. AI search ("find the email where John mentioned the budget") with results in conversation. AI panel coexists with inbox. | Niche, small user base. Some interactions feel unfinished. | **Closest comp to what we're building.** How search results appear within conversation. Side panel coexistence for Mac. |
| **Spark Mail** | Email-specific AI that understands inbox context. Results feel native to the email experience. Compose suggestions are solid. | Voice is an afterthought — just dictation. AI feels bolted on. | Inline email result rendering. AI responses that look like part of the email client, not a separate universe. |

### Side Panel AI (Mac reference)

| Product | What they do well | What they get wrong | What we steal |
|---------|-------------------|---------------------|---------------|
| **Arc Browser** | AI sidebar coexists with main content without fighting for attention. Narrow, text-focused, doesn't try to be a full app. | Limited capabilities. | Side panel layout principles for Mac. |
| **GitHub Copilot Chat** | Chat → AI does something → result inline. Executes actions in context. | Developer-focused, not consumer. | The "chat → tool call → result" pattern is exactly our voice flow in text form. |
| **Notion AI** | Inline AI within the content you're already looking at. Calm execution feedback — just does the thing and shows the result. | No voice, no real-time interaction. | How quiet execution feedback can be. |

### Animation & Ambient State

| Product | What they do well | What we steal |
|---------|-------------------|---------------|
| **Apple Weather** | Animated backgrounds that respond to conditions — ambient animation that communicates state without demanding attention. | Target level of restraint for gradient blobs. |
| **Calm / Headspace** | Breathing animations. Rhythmic, calming, purposeful. | If our gradient blobs feel like breathing, we've nailed it. If they feel like a music visualizer, we've gone too far. |

### Onboarding

| Product | What they do well | What we steal |
|---------|-------------------|---------------|
| **Alexa app (first setup)** | Shows example phrases, lets you try one, confirms it worked. | Similar pattern to our 4-step onboarding. |

### Top 3 to study first

1. **Claude Voice** — tonal reference (calm, restrained, non-spectacle)
2. **ChatGPT Voice Mode** — interaction mechanics (interruption, streaming, live conversation)
3. **Shortwave** — AI + email integration (search results in conversation, panel coexistence)

**Design takeaway:** The best voice UIs let the conversation BE the interface. The moment you add visible chrome, toolbars, or status dashboards, you've turned an assistant into an app-within-an-app. Our goal is the opposite — the user forgets they're using a feature and just... talks.

---

## Open Design Decisions

- [ ] Should the background gradient be Filo-branded (blue) or more neutral? Blue reinforces brand but may feel too "techy"
- [ ] Compose handoff: half-sheet or full-screen? Half-sheet preserves voice context but may feel cramped for long emails
- [ ] Should quick commands be static or contextual (based on inbox state)?
- [ ] Live mode vs. push-to-talk: current spec assumes continuous listening. Should there be a push-to-talk alternative for noisy environments?
- [ ] Conversation history persistence: clear on each session, or persist across sessions?

---

## Next Steps

1. Wireframe all screen states (Idle, Listening, Processing, Error, Permission)
2. Design tool result cards (search, compose, task, rule)
3. Prototype state transitions in Figma
4. Define gradient animation keyframes
5. Build interactive prototype for user testing
6. Dark mode pass on all screens
