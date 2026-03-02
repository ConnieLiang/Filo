# FILO-1740 — Filo Talk — iOS & Android Implementation

> Sub-task of [FILO-1674](https://xindong.atlassian.net/browse/FILO-1674)


| Field    | Value                                                                                                                               |
| -------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Jira     | [FILO-1740](https://xindong.atlassian.net/browse/FILO-1740)                                                                         |
| Parent   | [FILO-1674](https://xindong.atlassian.net/browse/FILO-1674)                                                                         |
| Platform | iOS, Android                                                                                                                        |
| Figma    | [🍎 Mobile — Talk](https://www.figma.com/design/7tXBqwb5MkT6wIwnjgeA4g/%F0%9F%8D%8E-Mobile?node-id=6847-80968&t=Akwp3eIlpUX1ahrS-1) |


---

## Overview

Filo Talk is a voice-driven AI conversation inside Filo's AI Tab. The user speaks, Filo acts on their email (search, archive, compose, reply, create tasks, set rules), and responds with voice. The conversation is continuous — no re-tapping, no re-prompting — until the user decides to end it.

---

## Design Prototype (HTML)

A fully interactive HTML prototype has been built covering all screen states, animations, dark mode, and voice playback. This is the **primary reference** for implementing Filo Talk on iOS and Android.

**File:** `Demo/filo-talk-mobile.html`

**Audio assets:** `Demo/audio/` — 33 MP3 files

- 20 greeting variations (`greeting-0` through `greeting-19`)
- 4 conversation AI responses (`conv-ai-1` through `conv-ai-4`)
- 3 onboarding audio (`onboarding-greeting`, `onboarding-pills`, `onboarding-reply`)
- 4 user recordings (`adam-onboarding`, `adam-conv-1`, `adam-conv-2`, `adam-error`)
- 2 error state audio (`error-archiving`, `error-card`)

**Image assets:** `Demo/assets/` — `gradient-bg.png`, `emily-avatar.png`

**Sound effects:** `Resources/Sounds/on.mp3` (open overlay), `Resources/Sounds/off.mp3` (close overlay) — pre-loaded for instant playback

---

## Screen States to Implement

### 1. Idle State (AI Tab default)

- **Navigation bar:** "Filo AI" title + settings gear button (top-right, 42pt circle, glass-morphism background)
- **Ambient gradient blobs:** 3 gaussian-blurred organic shapes (blue + purple) with slow drift animation, positioned in center area, low opacity (~0.24)
- **Quick command pills:** vertically stacked, left-aligned, icon + text:
  - "Summarize this week's emails"
  - "Find what needs to be done this week"
  - "Add a smart filter"
- **Input bar:** rounded 24px container with placeholder "Ask anything" + sparkle icon, mic button (36pt circle, dark fill, glow pulse animation)
- **"Tap to talk" tooltip** above mic button (0.8s fade-in, then persistent gentle float animation ±3px at 1.5s loop)
- **iOS 26-style glass pill tab bar** at bottom (Inbox, To-do, AI tabs + compose FAB)

### 2. Talk Overlay (Listening State)

- Triggered by tapping mic button in Idle or Talk button from Email Detail
- **Full-screen overlay** with clip-path circle morph animation from mic button position (0.55s cubic-bezier ease-out)
- **Greeting text:** word-by-word reveal with gradient highlight (20 randomized variations, personalized with user name)
- **Simultaneous TTS** voice playback of greeting (pre-generated MP3s)
- **Gradient blobs** at bottom: two states — `blobs-quiet` (opacity 0.55, scale 0.9, slow 8s) and `blobs-active` (opacity 1, scale 1.15, fast 2.5s)
- **Stop button:** pill-shaped, dark fill, 5-bar waveform animation + "Stop" label, centered at bottom
- **Settings gear** (top-right) opens voice selection context menu (Apple iOS-style: Alloy, Echo, Fable, Onyx, Nova, Shimmer)

### 3. Conversation State

- Full-screen voice conversation with chat-like message layout
- **AI messages:** left-aligned, plain text, word-by-word gradient reveal synced with voice playback
- **User messages:** right-aligned, italic, light blue tinted bubble (`rgba(76,180,255,0.12)`), pill shape for short / rounded rect for long
- **Typing dots** animation (3 dots, pulsing bounce) while processing user speech
- **AI Draft Card:** 24px rounded card with draft body + "Edit in Draft" / "Send Now" actions
- **Gradient blobs** at bottom with quiet/active states synced to AI speaking
- Sequential animation: messages appear one-by-one with staggered delays and per-message audio

### 4. Onboarding State (first-time only)

- Triggered when `hasSeenAITutorial == false`
- Step 1: AI greeting with word-by-word animation + voice
- Step 2: Quick command pills animate in with staggered delay — "Archive read emails", "Any new emails?", "Write a new email"
- Step 3: User taps a pill → pill becomes user message bubble with typing dots → done state
- Step 4: AI reply with voice: "You have 5 new emails since this morning..."
- Same gradient blobs and stop button as other states

### 5. Error States

- **Error A — Tool Failure:** User bubble → AI message "Archiving your newsletters..." → Error card (red/pink bg `#FFE5E7` / dark `#461D21`) with bold error text + "Try Again" button
- **Error B — Permission Denied:** Full-screen centered layout with microphone-X icon, title "Microphone Access Required", body text, primary CTA "Enable Microphone", secondary "Not now" link

### 6. Entry Point — Email Detail

- Talk button (50pt circle, dark fill, glow animation) at bottom-right of email detail, alongside reply bar
- Tapping opens Talk Overlay with clip-path morph from button position
- Email context visible behind overlay before it opens

---

## Design System Tokens

### Color Tokens (Light / Dark)


| Token           | Light                    | Dark                     |
| --------------- | ------------------------ | ------------------------ |
| Primary Blue    | `#1F9EFA`                | `#6CC1FF`                |
| Background      | `#FFFFFF`                | `#1D1D21`                |
| Surface         | `#F5F5F5`                | `#2A2A30`                |
| Text Primary    | `#000000`                | `#FFFFFF`                |
| Text Secondary  | `#707070`                | `#8B8B8B`                |
| Text Tertiary   | `#9E9E9E`                | `#727272`                |
| Divider         | `#D5D5D5`                | `#414149`                |
| User Bubble BG  | `rgba(76,180,255,0.12)`  | `rgba(76,180,255,0.12)`  |
| Error BG        | `#FFE5E7`                | `#461D21`                |
| Blob 1 (Blue)   | `rgba(157,222,255,0.7)`  | `rgba(69,177,255,0.25)`  |
| Blob 2 (Purple) | `rgba(127,110,255,0.45)` | `rgba(127,110,255,0.2)`  |
| Blob 3 (Blue)   | `rgba(34,160,251,0.4)`   | `rgba(69,177,255,0.18)`  |
| Glass Pill Tab  | `rgba(247,247,247,0.85)` | `rgba(40,40,40,0.85)`    |
| Subtle BG       | `rgba(0,0,0,0.04)`       | `rgba(255,255,255,0.06)` |


### Animation Specs


| Animation              | Duration / Easing                   | Notes                                  |
| ---------------------- | ----------------------------------- | -------------------------------------- |
| Talk Overlay open      | 0.55s `cubic-bezier(0,0,0.2,1)`     | clip-path circle morph from mic button |
| Talk Overlay close     | 0.4s `cubic-bezier(0.4,0,1,1)`      | Circle shrinks back to origin          |
| Word reveal            | 0.5s per word, 220ms stagger        | Gradient background-position sweep     |
| Blob float (idle)      | 4–6s ease-in-out infinite           | translate + scale keyframes, 3 blobs   |
| Blob float (quiet)     | 8s                                  | Scale 0.9, opacity 0.55                |
| Blob float (active)    | 2.5s                                | Scale 1.15, opacity 1.0                |
| Mic glow               | 2.5s ease-in-out infinite           | box-shadow pulse: 12px→24px blue glow  |
| Waveform bars          | 1.2s ease-in-out infinite           | 5 bars, scaleY(0.5→1), 0.1s stagger    |
| Onboarding pill appear | 0.4s ease + cubic-bezier(0.2,0,0,1) | translateY(12→0), scale(0.95→1)        |
| Message appear         | 0.35s ease                          | translateY(8→0), opacity(0→1)          |
| Tooltip fade-in        | 0.8s ease                           | Opacity 0→1, translateY(4→0)           |
| Tooltip float          | 1.5s ease-in-out infinite           | Persistent ±3px vertical float         |


---

## iOS Implementation Guide (Swift/SwiftUI)

### Recommended File Structure

```
FiloTalkModule/
├── Views/
│   ├── AITabView.swift              (container: switches Idle / Talk / Conversation)
│   ├── IdleStateView.swift           (gradient blobs + quick commands + input bar)
│   ├── TalkOverlayView.swift         (full-screen listening overlay)
│   ├── ConversationView.swift        (message list + gradient + stop button)
│   ├── OnboardingFlowView.swift      (first-time tutorial)
│   ├── ErrorPermissionView.swift     (mic permission denied screen)
│   └── Components/
│       ├── GradientBlobView.swift     (animated gaussian blur circles)
│       ├── WaveformView.swift         (5-bar waveform animation)
│       ├── WordRevealText.swift       (word-by-word gradient text reveal)
│       ├── VoiceMenuView.swift        (iOS context menu for voice selection)
│       ├── QuickCommandPill.swift     (icon + text pill button)
│       ├── DraftCardView.swift        (AI draft with Send/Edit actions)
│       └── ErrorCardView.swift        (error card with retry)
├── ViewModels/
│   ├── FiloTalkViewModel.swift        (@Observable, state machine: idle → listening → processing → responding)
│   └── VoiceSessionManager.swift      (audio recording + STT + TTS orchestration)
├── Models/
│   ├── TalkState.swift                (enum: idle, listening, processing, responding, error)
│   ├── ConversationMessage.swift      (model for AI/user messages)
│   └── VoiceConfig.swift              (selected voice, settings)
└── Services/
    ├── SpeechRecognizer.swift          (SFSpeechRecognizer wrapper)
    ├── AudioPlayer.swift               (AVAudioPlayer for TTS streaming playback)
    └── HapticManager.swift             (UIImpactFeedbackGenerator)
```

### Key Technical Decisions

#### 1. Gradient Blob Animation

The HTML uses CSS `blur()` + keyframe animations. For iOS:

- **Recommended:** SwiftUI `Canvas` + `TimelineView`. Draw 3 `Circle()` with `.blur(radius: 45)`. Animate position/scale using `TimelineView` for 60fps. Use `withAnimation(.easeInOut(duration: 4).repeatForever())` for drift.
- **Performance option:** Metal shader via `CAMetalLayer` for GPU blur on older devices. Use `CADisplayLink` for frame sync.
- **Blob states:**
  - Idle: opacity 0.24, scale 1.0
  - Quiet (AI speaking): opacity 0.55, scale 0.9
  - Active (user speaking): opacity 1.0, scale 1.15
  - Transition: 0.8s easeInOut between states
- **Audio reactivity:** Pipe microphone amplitude from `AVAudioEngine.installTap(onBus:)` into blob scale/opacity modifiers.

#### 2. Talk Overlay Transition (clip-path → SwiftUI)

The HTML uses CSS `clip-path: circle()`. In SwiftUI:

```swift
struct CircleRevealModifier: ViewModifier {
    var isPresented: Bool
    var origin: CGPoint
    
    func body(content: Content) -> some View {
        content
            .clipShape(
                Circle()
                    .scale(isPresented ? 3.0 : 0.001)
                    .offset(x: origin.x - UIScreen.main.bounds.width / 2,
                            y: origin.y - UIScreen.main.bounds.height / 2)
            )
            .animation(.easeOut(duration: 0.55), value: isPresented)
    }
}
```

Alternative: Use `matchedGeometryEffect` or `UIViewControllerTransitioningDelegate` for more control.

#### 3. Word-by-Word Text Reveal

The HTML animates `background-position` on each word for a gradient sweep. In SwiftUI:

- Split text into words, render each as separate `Text()` in a `FlowLayout` (or wrapped `HStack`)
- Use `.foregroundStyle` with a gradient mask that shifts from secondary → primary color
- Stagger reveal at ~220ms per word using `Task.sleep` + incremental `@State` counter
- Sync with `AVAudioPlayer.currentTime` for word-level audio alignment

#### 4. Voice I/O Pipeline

```
User speaks → AVAudioEngine (mic input)
           → SFSpeechRecognizer (on-device STT, iOS 17+)
           → Real-time transcription text
           → Send to AI backend
           → Stream response text + TTS audio (server-side)
           → AVAudioPlayer (sentence-by-sentence playback)
           → Word-by-word text reveal synced to playback
```

- Use `SFSpeechRecognizer` with on-device recognition (iOS 17+) for low latency
- `AVAudioSession` category: `.playAndRecord` with `.defaultToSpeaker` and `.allowBluetooth`
- Handle interruptions via `AVAudioSession.interruptionNotification`
- Silence detection: monitor audio levels, trigger timeout after 10s (< -50dB)

#### 5. Permission Handling

- Microphone: `AVAudioApplication.requestRecordPermission()`
- Speech: `SFSpeechRecognizer.requestAuthorization()`
- Show custom pre-permission screen BEFORE triggering iOS system dialogs (Error State B design)
- If permanently denied: `UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)`

#### 6. Glass Pill Tab Bar (iOS 26)

- For iOS 26+: maps to the new liquid glass tab bar API
- For iOS 17–18: custom `TabBar` with `.background(.ultraThinMaterial)`, `cornerRadius(100)`, shadow, vibrancy

#### 7. Accessibility

- Check `UIAccessibility.isReduceMotionEnabled` — replace blob animations with static gradient at 0.15 opacity, opacity-only fades for transitions
- VoiceOver: announce state changes ("Recording", "Filo is thinking", "Response: ...")
- Dynamic Type: all text uses system font metrics, pills wrap at larger sizes
- 44pt minimum tap targets for all interactive elements

#### 8. Haptics

- Mic button tap: `UIImpactFeedbackGenerator(style: .medium)`
- Stop button tap: `UIImpactFeedbackGenerator(style: .light)`
- Error card appear: `UINotificationFeedbackGenerator(.error)`

---

## Android Implementation Guide (Kotlin / Jetpack Compose)

### Recommended File Structure

```
filo-talk/  (or feature module)
├── ui/
│   ├── AITabScreen.kt                 (container: switches Idle / Talk / Conversation)
│   ├── IdleStateScreen.kt             (gradient blobs + quick commands + input bar)
│   ├── TalkOverlayScreen.kt           (full-screen listening overlay)
│   ├── ConversationScreen.kt         (message list + gradient + stop button)
│   ├── OnboardingFlowScreen.kt        (first-time tutorial)
│   ├── ErrorPermissionScreen.kt       (mic permission denied screen)
│   └── components/
│       ├── GradientBlob.kt             (animated gaussian blur circles)
│       ├── WaveformBars.kt            (5-bar waveform animation)
│       ├── WordRevealText.kt          (word-by-word gradient text reveal)
│       ├── VoiceMenu.kt               (dropdown / popup for voice selection)
│       ├── QuickCommandPill.kt        (icon + text pill button)
│       ├── DraftCard.kt               (AI draft with Send/Edit actions)
│       └── ErrorCard.kt               (error card with retry)
├── viewmodel/
│   ├── FiloTalkViewModel.kt           (state: idle → listening → processing → responding)
│   └── VoiceSessionManager.kt         (audio recording + STT + TTS orchestration)
├── domain/ or model/
│   ├── TalkState.kt                   (enum: idle, listening, processing, responding, error)
│   ├── ConversationMessage.kt         (model for AI/user messages)
│   └── VoiceConfig.kt                 (selected voice, settings)
└── data/ or service/
    ├── SpeechRecognizer.kt             (android.speech.SpeechRecognizer wrapper)
    ├── AudioPlayer.kt                 (ExoPlayer or MediaPlayer for TTS streaming)
    └── HapticHelper.kt                (performHapticFeedback)
```

### Key Technical Decisions

#### 1. Gradient Blob Animation

The HTML uses CSS `blur()` + keyframe animations. For Android (Compose):

- **Recommended:** `Canvas` + `Animatable` (or `infiniteRepeatable` with `tween`) for position/scale. Draw 3 circles with `drawCircle`; apply `RenderEffect.createBlurEffect()` (API 31+) or use a `BlurredEdgeTreatment` / custom `Modifier.blur()`-style effect. Use `LaunchedEffect` + `animateFloat` in a loop for 60fps-friendly updates.
- **Performance option:** RenderScript blur (deprecated) or custom RenderEffect; prefer `RenderEffect.createBlurEffect` on API 31+.
- **Blob states:** Same as iOS — idle (0.24f, 1f), quiet (0.55f, 0.9f), active (1f, 1.15f). Transition with `animateFloatAsState` (0.8s, FastOutSlowInEasing).
- **Audio reactivity:** Use `AudioRecord` with `read()` in a coroutine; compute RMS amplitude and feed into blob scale/alpha state.

#### 2. Talk Overlay Transition (clip-path circle → Compose)

The HTML uses `clip-path: circle()`. In Compose:

- Use `Modifier.clip(CircleShape)` with an `Animatable` for scale (0.001f → 3f) and offset so the circle expands from the mic button coordinates. Animate with `Animatable` or `animateFloatAsState`; duration 550ms, FastOutSlowInEasing.
- Alternative: `androidx.compose.animation.AnimatedContent` or a custom `GraphicLayer` with `clip = true` and a circular path that grows from the tap point (e.g. `Path().addCircle` with animated radius).

```kotlin
// Concept: overlay with clip that animates from button position
val scale by animateFloatAsState(if (visible) 3f else 0.001f, animationSpec = tween(550))
val offsetX = buttonCenter.x - screenWidth / 2f
val offsetY = buttonCenter.y - screenHeight / 2f
Box(
    modifier = Modifier
        .fillMaxSize()
        .graphicsLayer {
            clip = true
            shape = CircleShape
            scaleX = scale
            scaleY = scale
            translationX = offsetX
            translationY = offsetY
        }
) { /* overlay content */ }
```

#### 3. Word-by-Word Text Reveal

- Split string into words; use `FlowRow` or `Row(modifier = Modifier.wrapContentWidth())` with each word as a `Text` composable.
- Use `Brush.linearGradient` or `Brush.horizontalGradient` with `Modifier.drawWithContent` / `Modifier.graphicsLayer` to mask from secondary to primary color; animate gradient stop or use per-word `alpha` / color driven by a staggered delay (~220ms per word) via `LaunchedEffect` + `delay`.
- Sync with `ExoPlayer`/`MediaPlayer` current position for word-level alignment if needed.

#### 4. Voice I/O Pipeline

```
User speaks → AudioRecord (mic input)
           → SpeechRecognizer (android.speech) or Google ML Kit Speech-to-Text
           → Real-time transcription (onResult callbacks)
           → Send to AI backend
           → Stream response text + TTS audio (server-side)
           → ExoPlayer or MediaPlayer (sentence-by-sentence playback)
           → Word-by-word text reveal synced to playback
```

- Use `android.speech.SpeechRecognizer` with `RecognizerIntent`; for on-device low latency consider ML Kit or device OEM APIs where available.
- `AudioManager.STREAM_MUSIC` / `AudioAttributes` for playback; `MODIFY_AUDIO_SETTINGS` and `RECORD_AUDIO` permissions.
- Handle `AudioManager` focus and interruptions (e.g. `OnAudioFocusChangeListener`).
- Silence detection: compute level from `AudioRecord.read()` buffer, trigger timeout after 10s below threshold.

#### 5. Permission Handling

- Microphone: `ActivityResultContracts.RequestPermission()` for `Manifest.permission.RECORD_AUDIO`.
- (Optional) Speech: if using a cloud STT API, no special Android permission beyond network; if using on-device, RECORD_AUDIO covers it.
- Show custom pre-permission screen before calling `Activity.requestPermissions()` / `rememberLauncherForActivityResult` (same as Error State B design).
- If permanently denied: `Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)` with package URI, or `ACTION_APPLICATION_SETTINGS`.

#### 6. Bottom Navigation (Material 3)

- Use `NavigationBar` (Material 3) or custom composable with `Surface(shape = RoundedCornerShape(percent = 50))` + `Modifier.blur()` (API 31+) or semi-transparent background to approximate glass pill. Same structure: Inbox, To-do, AI tabs + FAB for compose.

#### 7. Accessibility

- Respect `Settings.Global.getFloat(ANIMATOR_DURATION_SCALE, 1f)` or check for reduced motion — use static gradient and opacity-only transitions.
- `ContentDescription` on all interactive elements; ` semantics { liveRegion = LiveRegionMode.Polite }` for state changes ("Recording", "Filo is thinking", "Response: ...").
- `Modifier.minimumInteractiveComponentSize()` (48.dp) for tap targets; support large font / display size.

#### 8. Haptics

- Mic button tap: `view.performHapticFeedback(HapticFeedbackConstants.LONG_PRESS)` or `HapticFeedbackConstants.CONTEXT_CLICK`
- Stop button: `HapticFeedbackConstants.CONTEXT_CLICK` (light)
- Error card appear: `HapticFeedbackConstants.REJECT` or `CONFIRM` as appropriate

---

## Acceptance Criteria

(Applies to both **iOS** and **Android**.)

1. All 6 screen states render correctly in both Light and Dark mode
2. Talk Overlay opens with circle-reveal animation from mic button position
3. Gradient blobs animate smoothly at 60fps, respond to audio amplitude during active voice
4. Word-by-word text reveal syncs with TTS audio playback
5. Voice selection context menu works and persists choice
6. Permission flow handles all states (first ask, denied, permanently denied → Settings redirect)
7. Onboarding flow plays through exactly once, marks `hasSeenAITutorial`
8. Error states show correct error card / retry button / permission screen
9. Entry point from Email Detail opens Talk Overlay with correct context
10. Reduced Motion is respected — no blob animation, opacity-only transitions

