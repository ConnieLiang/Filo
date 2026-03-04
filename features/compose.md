# Feature Spec: Compose

Compose helps users respond quickly and clearly. Instant Write is the AI layer that drafts replies without taking over the user's voice.

---

## Overview

The compose experience covers new emails, replies, reply-all, and forwards. It is designed for speed: get the user in, help them write, and get them out. Instant Write assists without prompting — it suggests, the user accepts or edits.

---

## Layout

### Fields

| Field | Typography | Notes |
|-------|------------|-------|
| To | P2_R (16px regular) | Tokenized chips for recipients, auto-complete from contacts |
| Cc / Bcc | P2_R | Hidden by default, revealed via toggle |
| Subject | P2_B (16px bold) | Pre-filled on reply/forward |
| Body | P1.1_R (17px regular) | Main editing area, minimum height ~200px |

### Toolbar (Bottom)

Formatting actions in a single row:

| Action | Icon | Notes |
|--------|------|-------|
| Bold | `boldtext` | Toggle |
| Italic | `italic` | Toggle |
| Underline | `underline` | Toggle |
| Strikethrough | `strikethrough` | Toggle |
| Bullet list | `bulletlist` | Toggle |
| Number list | `numberlist` | Toggle |
| Link | `link` | Opens link input |
| Attachment | `attachment` | Opens file picker |
| Image | `image` | Opens image picker |

### Action Bar (Top / Nav)

| Action | Position | Notes |
|--------|----------|-------|
| Cancel / Discard | Left | Prompts confirmation if body has content |
| Send | Right | Primary button, filled style, primary color (#02) |

### Spacing

- Field padding: 16px horizontal (space-4), 12px vertical (space-3)
- Fields separated by subtle divider (0.5px, #14)
- Toolbar: 44px height minimum (touch target), icons spaced 20px apart
- Body area: 16px padding all sides

---

## Instant Write (AI-Assisted Reply)

### Trigger

- On reply/forward, if the original email has actionable content, Instant Write suggests a draft automatically.
- A subtle banner appears above the body: "Suggestion ready" with a single tap/click to insert.
- No forced modal. No chatbot interaction. The suggestion simply appears.

### Tone Controls

When Instant Write is active, a small pill bar appears above the toolbar:

| Tone | Icon | Description |
|------|------|-------------|
| Professional | `professional` | Default for work contexts |
| Friendly | `friendly` | Warmer, less formal |
| Shorter | `shorter` | Condenses the draft |
| Longer | `longer` | Expands with more detail |

Tapping a tone pill regenerates the suggestion. Maximum one regeneration per tone to avoid infinite loops.

### Proofread

Before sending, Instant Write can proofread the final text:
- Icon: `proofread` in the toolbar
- Highlights issues inline (grammar, clarity, tone mismatch)
- User accepts/rejects each suggestion individually

### Translate

- Icon: `translate` in toolbar
- Translates the composed body to a selected language
- Preserves formatting

---

## Interactions

### Send

- Tap/click Send button.
- Brief undo window (3 seconds) via a bottom toast: "Email sent. Undo"
- After undo window, email is sent and moves to Sent folder.

### Discard

- If body is empty: dismiss immediately, no confirmation.
- If body has content: show confirmation dialog — "Discard draft?" with Save Draft and Discard options.
- Draft auto-saves every 10 seconds while composing.

### Attachments

- Tap attachment icon → system file picker.
- Attached files shown as chips below the body area.
- Chip shows: file icon, file name (truncated), file size, remove (×) button.
- Max attachment size: follow provider limits, show error if exceeded.

---

## Platform-Specific Notes

### Desktop (Electron + React + Radix UI)

- Compose opens as a panel in the right pane or a floating window (user preference).
- Keyboard shortcuts: Cmd+Enter to send, Cmd+Shift+A for attach, Esc to close.
- Rich text editing via a lightweight editor (e.g., TipTap or Lexical).
- Drag-and-drop attachments into the body area.

### iOS (Swift / SwiftUI)

- Compose opens as a modal sheet (full-screen on iPhone, sheet on iPad).
- Navigation bar: Cancel (left), Send (right) per iOS Liquid Glass nav bar spec.
- Keyboard avoidance: toolbar stays pinned above keyboard.
- Swipe down to minimize (save as draft).
- Respect Dynamic Type for body text.

### Android (Kotlin)

- Compose opens as a new activity or full-screen Compose destination.
- System back button: prompt to save draft if body has content.
- Toolbar above keyboard via `WindowInsets` handling.
- Share intent: Filo appears as a share target for composing emails with attachments from other apps.
- Respect Material You dynamic theming for system-level consistency, but Filo tokens take precedence in the compose area.

---

## Empty State

New compose (not reply/forward):

- Cursor in To field by default.
- Body area shows placeholder text in text-tertiary (#08): "What do you want to say?"
- No templates, no prompts, no suggested subjects. Just a blank canvas.
