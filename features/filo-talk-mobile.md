# Feature Spec: Filo Talk (Mobile)

Voice-driven AI conversation inside the AI Tab. The user speaks, Filo acts on email, and responds with voice. Continuous — no re-tapping, no re-prompting.

**Prototype:** `Demo/filo-talk-mobile.html`
**Audio assets:** `Demo/audio/` (33 MP3 files)
**Jira:** FILO-1674, FILO-1740

---

## Screen States

### 1. Idle (AI Tab Default)

| Element | Spec |
|---------|------|
| Nav bar | "Filo AI" title + settings gear (42pt circle, glass background) |
| Gradient blobs | 3 gaussian-blurred shapes (blue + purple), center area, opacity ~0.24, slow drift |
| Quick command pills | Vertical stack, left-aligned, icon + text. "Summarize this week's emails", "Find what needs to be done this week", "Add a smart filter" |
| Input bar | Rounded 24px, placeholder "Ask anything" + sparkle icon, mic button (36pt circle, dark fill, glow pulse) |
| Tooltip | "Tap to talk" above mic, 0.8s fade-in, persistent ±3px float at 1.5s loop |
| Tab bar | iOS 26 glass pill (Inbox, To-do, AI) + compose FAB |

**Empty state (no conversation history):**
- Centered `ai-main` icon
- "Hi, I'm your Filo AI assistant" (P1_M, text-secondary)
- "Ask me anything about your emails" (P3_R, text-tertiary)
- Quick commands below greeting

### 2. Talk Overlay (Listening)

Triggered by tapping mic button. Full-screen overlay with circle morph animation from mic position.

| Element | Spec |
|---------|------|
| Transition | clip-path circle expand, 0.55s cubic-bezier(0,0,0.2,1) |
| Greeting | Word-by-word reveal with gradient highlight, 20 randomized variations, personalized with user name |
| TTS | Simultaneous voice playback of greeting (pre-generated MP3s) |
| Gradient blobs | Bottom third. Quiet: opacity 0.55, scale 0.9, 8s drift. Active (user speaking): opacity 1.0, scale 1.15, 2.5s |
| Stop button | Pill-shaped, dark fill, 5-bar waveform animation + "Stop" label, bottom center |
| Settings gear | Top-right, opens voice selection menu (Alloy, Echo, Fable, Onyx, Nova, Shimmer) |
| Transcription | Live text center-screen, P1_M, max 3 visible lines. Previous lines fade to text-tertiary |
| Status | "Listening..." label at top, P4_R, text-tertiary |

### 3. Conversation

Full-screen voice conversation with chat-like layout.

| Element | Spec |
|---------|------|
| AI messages | Left-aligned, plain text, word-by-word gradient reveal synced with voice playback |
| User messages | Right-aligned, italic, blue tint bubble (`rgba(76,180,255,0.12)`), pill for short / rounded rect for long |
| Typing indicator | 3 dots, pulsing bounce, while processing user speech |
| AI Draft Card | 24px rounded card with draft body + "Edit in Draft" / "Send Now" actions |
| Gradient blobs | Bottom, quiet/active states synced to AI speaking |
| Message animation | Staggered appear: translateY(8→0), opacity(0→1), 0.35s ease |

**Action results in conversation:**

| Action | AI Response |
|--------|-------------|
| Search | "Found X emails from [name]" + up to 5 email preview cards. "View all X results" if more |
| Compose/Reply | "I'll draft that for you" → half-sheet compose slides up, pre-filled. Send/Edit/Cancel |
| Batch action | "Archived X emails" + undo toast (3s) |
| Create task | "Task created" + task card inline |
| Create rule | "Rule created" + rule summary card |

### 4. Onboarding (First-Time Only)

Triggered when `hasSeenAITutorial == false` and mic permission granted.

1. AI greeting with word-by-word animation + voice
2. Quick command pills animate in (staggered 100ms): "Archive read emails", "Any new emails?", "Write a new email"
3. User taps a pill → becomes user message bubble with typing dots → AI processes
4. AI reply with voice: "You have 5 new emails since this morning..."
5. Mark `hasSeenAITutorial = true`

### 5. Compose/Reply Handoff

- Voice mode pauses (gradient freezes, no recording)
- Compose sheet slides up (medium detent on iOS, bottom sheet on Android)
- Draft pre-filled by AI. User reviews → Send / Edit / Cancel
- On dismiss, voice resumes. AI confirms: "Email sent" or "Draft discarded"

### 6. Entry Point — Email Detail

- Talk button: 50pt circle, dark fill, glow animation, bottom-right alongside reply bar
- Opens Talk Overlay with circle morph from button position
- Email context visible behind overlay before open

---

## Error States

| Error | Trigger | UI |
|-------|---------|-----|
| E1: Mic denied (first ask) | Tap mic, no permission | Pre-permission screen: mic icon, "Voice needs microphone access", body explaining real-time processing, "Allow Microphone" CTA, "Not now" link |
| E1: Mic denied (permanent) | Previously denied in Settings | Mic button disabled (text-tertiary). On tap: inline banner "Microphone access is off" + "Open Settings" link |
| E2: Speech recognition denied | Mic granted, speech auth denied | Same pattern as E1, copy about speech recognition. Fallback: server-only transcription, show "Transcribing..." |
| E3: Network error | Connection lost mid-conversation | Inline error message, error background (#FFE5E7 / #461D21), "Retry" button |
| E4: STT failure | Speech-to-text garbage/fail | AI message: "Sorry, I didn't catch that. Could you try again?" — conversational, no special error UI |
| E5: Tool failure | Backend action fails | Error card (red/pink bg) with bold error text + "Try Again" button |
| E6: Silence timeout | No speech for 10s | "Still there?" (P3_R, text-tertiary). 5 more seconds → auto-return to Idle |
| E7: Rate limit | Free plan voice quota exceeded | AI message with upgrade CTA (subtle, not aggressive). Text input stays functional. Mic shows disabled + "Plus" badge |

---

## Animation Specs

| Animation | Duration / Easing | Notes |
|-----------|-------------------|-------|
| Talk Overlay open | 0.55s cubic-bezier(0,0,0.2,1) | clip-path circle morph from mic button |
| Talk Overlay close | 0.4s cubic-bezier(0.4,0,1,1) | Circle shrinks back to origin |
| Word reveal | 0.5s per word, 220ms stagger | Gradient background-position sweep |
| Blob float (idle) | 4–6s ease-in-out infinite | translate + scale, 3 blobs |
| Blob float (quiet) | 8s | Scale 0.9, opacity 0.55 |
| Blob float (active) | 2.5s | Scale 1.15, opacity 1.0 |
| Mic glow | 2.5s ease-in-out infinite | box-shadow pulse: 12px→24px blue glow |
| Waveform bars | 1.2s ease-in-out infinite | 5 bars, scaleY(0.5→1), 0.1s stagger |
| Pill appear | 0.4s ease + cubic-bezier(0.2,0,0,1) | translateY(12→0), scale(0.95→1) |
| Message appear | 0.35s ease | translateY(8→0), opacity(0→1) |
| Tooltip fade-in | 0.8s ease | Opacity 0→1, translateY(4→0) |
| Tooltip float | 1.5s ease-in-out infinite | ±3px vertical float |

**Reduced Motion:** All blob animations → static gradient at 0.15 opacity. All transitions → opacity-only fades.

---

## Color Tokens (Filo Talk-Specific)

| Token | Light | Dark |
|-------|-------|------|
| User bubble bg | `rgba(76,180,255,0.12)` | `rgba(76,180,255,0.12)` |
| Blob 1 (blue) | `rgba(157,222,255,0.7)` | `rgba(69,177,255,0.25)` |
| Blob 2 (purple) | `rgba(127,110,255,0.45)` | `rgba(127,110,255,0.2)` |
| Blob 3 (blue) | `rgba(34,160,251,0.4)` | `rgba(69,177,255,0.18)` |

Standard Filo tokens for everything else (background, text, error, surface — see `tokens.json`).

---

## Voice Configuration

- **Default voice:** `nova` — warm, clear, natural. No voice selection in MVP (opinionated default).
- **Post-MVP:** Voice selection in Settings > AI > Voice. Not on the main voice screen.
- **Playback:** Streaming PCM, sentence-by-sentence. First chunk within 1s of AI response start. Text leads audio slightly.
- **Sound effects:** `Resources/Sounds/on.mp3` (overlay open), `Resources/Sounds/off.mp3` (overlay close)

---

## Platform-Specific Notes

### iOS (Swift / SwiftUI)

**File structure:**

```
FiloTalkModule/
├── Views/
│   ├── AITabView.swift              # Container: Idle / Talk / Conversation
│   ├── IdleStateView.swift
│   ├── TalkOverlayView.swift
│   ├── ConversationView.swift
│   ├── OnboardingFlowView.swift
│   ├── ErrorPermissionView.swift
│   └── Components/
│       ├── GradientBlobView.swift
│       ├── WaveformView.swift
│       ├── WordRevealText.swift
│       ├── QuickCommandPill.swift
│       ├── DraftCardView.swift
│       └── ErrorCardView.swift
├── ViewModels/
│   ├── FiloTalkViewModel.swift      # @Observable, state machine
│   └── VoiceSessionManager.swift
├── Models/
│   ├── TalkState.swift              # enum: idle, listening, processing, responding, error
│   ├── ConversationMessage.swift
│   └── VoiceConfig.swift
└── Services/
    ├── SpeechRecognizer.swift       # SFSpeechRecognizer wrapper
    ├── AudioPlayer.swift
    └── HapticManager.swift
```

**Key decisions:**

- **Gradient blobs:** SwiftUI `Canvas` + `TimelineView`, 3 circles with `.blur(radius: 45)`. Audio reactivity via `AVAudioEngine.installTap(onBus:)`.
- **Circle reveal:** Custom `ViewModifier` with `clipShape(Circle().scale(...))`, 0.55s easeOut. Or `matchedGeometryEffect`.
- **Word reveal:** Split into separate `Text()` views, `.foregroundStyle` gradient mask, staggered at 220ms via `Task.sleep`.
- **Voice pipeline:** `AVAudioEngine` → `SFSpeechRecognizer` (on-device, iOS 17+) → AI backend → `AVAudioPlayer` streaming.
- **Audio session:** `.playAndRecord`, `.defaultToSpeaker`, `.allowBluetooth`. Handle interruptions via `interruptionNotification`.
- **Permissions:** Show custom pre-permission screen before iOS system dialog. If denied: `UIApplication.openSettingsURL`.
- **Tab bar:** iOS 26+ native Liquid Glass. iOS 17–18: custom with `.background(.ultraThinMaterial)`, cornerRadius(100).
- **Haptics:** Mic tap → `.medium` impact. Stop tap → `.light` impact. Error card → `.error` notification.
- **Accessibility:** Check `UIAccessibility.isReduceMotionEnabled`. VoiceOver labels on all states. Dynamic Type respected. 44pt touch targets.

### Android (Kotlin / Jetpack Compose)

**File structure:**

```
filo-talk/
├── ui/
│   ├── AITabScreen.kt
│   ├── IdleStateScreen.kt
│   ├── TalkOverlayScreen.kt
│   ├── ConversationScreen.kt
│   ├── OnboardingFlowScreen.kt
│   ├── ErrorPermissionScreen.kt
│   └── components/
│       ├── GradientBlob.kt
│       ├── WaveformBars.kt
│       ├── WordRevealText.kt
│       ├── QuickCommandPill.kt
│       ├── DraftCard.kt
│       └── ErrorCard.kt
├── viewmodel/
│   ├── FiloTalkViewModel.kt
│   └── VoiceSessionManager.kt
├── model/
│   ├── TalkState.kt
│   ├── ConversationMessage.kt
│   └── VoiceConfig.kt
└── service/
    ├── SpeechRecognizer.kt
    ├── AudioPlayer.kt
    └── HapticHelper.kt
```

**Key decisions:**

- **Gradient blobs:** `Canvas` composable + `animateFloat` infinite loop. Blur via `RenderEffect.createBlurEffect()` (API 31+). Audio reactivity from `AudioRecord.read()` in coroutine.
- **Circle reveal:** `Modifier.graphicsLayer { clip = true; shape = CircleShape; scaleX/Y = animated }` expanding from button coordinates.
- **Word reveal:** `FlowRow` with per-word `Text`, `Brush.linearGradient` mask, staggered alpha via `LaunchedEffect` + `delay(220)`.
- **Voice pipeline:** `AudioRecord` → `android.speech.SpeechRecognizer` → AI backend → `ExoPlayer` sentence-by-sentence.
- **Permissions:** `ActivityResultContracts.RequestPermission()` for `RECORD_AUDIO`. Custom pre-permission screen. If denied: `Settings.ACTION_APPLICATION_DETAILS_SETTINGS`.
- **Back button:** In Talk Overlay → close overlay, return to Idle. In Conversation → pause voice, return to Idle. Use `BackHandler`.
- **Bottom nav:** Material 3 `NavigationBar` or custom with `RoundedCornerShape(50)` + semi-transparent background.
- **Haptics:** Mic tap → `LONG_PRESS`. Stop → `CONTEXT_CLICK`. Error → `REJECT`.
- **Accessibility:** Check `ANIMATOR_DURATION_SCALE`. `semantics { liveRegion = Polite }` for state changes. `minimumInteractiveComponentSize()` (48dp).

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
| ai_type_message | Ask anything | 输入消息... |

### Quick Commands

| Key | EN | ZH |
|-----|----|----|
| ai_quick_summarize | Summarize this week's emails | 总结本周邮件 |
| ai_quick_todo | Find what needs to be done this week | 找出本周待办 |
| ai_quick_filter | Add a smart filter | 添加智能过滤 |

### Onboarding

| Key | EN | ZH |
|-----|----|----|
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

## New Components Required

| Component | Description |
|-----------|-------------|
| VoiceInputBar | Text input + mic button. Mic swaps to send when text entered |
| QuickCommandPill | Icon + text pill, surface secondary bg, full radius |
| GradientBlob | Animated organic shape with gaussian blur, responds to audio amplitude |
| TranscriptionDisplay | Center-screen streaming text with line fade, max 3 lines |
| WordRevealText | Word-by-word gradient text reveal, synced with TTS audio |
| WaveformBars | 5-bar waveform in stop button, scaleY animation |
| ToolResultCard | Contextual card for search results, tasks, rules |
| DraftCard | AI draft preview with Send/Edit actions, 24px radius |
| PermissionPrimer | Pre-permission screen: icon, title, body, CTA. Reusable for mic + speech |
| ErrorCard | Error bg + bold text + retry button |
| ComposeHalfSheet | Sheet for compose/reply with pre-filled draft |

---

## Icon Usage

| Use | Icon |
|-----|------|
| Mic button | `microphone-circle` |
| Mic disabled | `microphone-circle` + tertiary color |
| Stop | `stop` |
| Send text | `send-message` |
| Settings | `settings` |
| AI avatar | `ai-main` |
| Close | `close-minimal` |
| Error | `error` |
| Volume | `Volumn_High` / `Volumn_Off` |

---

## Acceptance Criteria

1. All 6 screen states render correctly in both light and dark mode
2. Talk Overlay opens with circle-reveal animation from mic button position
3. Gradient blobs animate at 60fps, respond to audio amplitude during active voice
4. Word-by-word text reveal syncs with TTS audio playback
5. Voice selection menu works and persists choice
6. Permission flow handles all states (first ask, denied, permanently denied → Settings redirect)
7. Onboarding plays through exactly once, marks `hasSeenAITutorial`
8. Error states show correct card / retry / permission screen
9. Entry point from Email Detail opens Talk Overlay with correct context
10. Reduced Motion respected — no blob animation, opacity-only transitions
