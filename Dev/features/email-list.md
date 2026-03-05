# Feature Spec: Email List

The email list is Filo's primary surface. It must answer "Do I need to care?" within a glance.

---

## Overview

The email list displays incoming messages grouped and labeled by AI. Users scan the list to identify what matters, act on what's urgent, and dismiss the rest. This is where cognitive load is either reduced or created — every detail counts.

---

## Layout

### Each Row Contains

| Element | Position | Typography | Notes |
|---------|----------|------------|-------|
| Avatar | Left, circular | — | Sender's profile image or initials |
| Sender name | Top-left of text block | P2_B (16px bold) | Bolded when unread |
| Subject line | Below sender | P2_R (16px regular) | Single-line, truncated with ellipsis |
| Preview text | Below subject | P3_R (15px regular), text-secondary (#07) | 1 line max, optional |
| Timestamp | Top-right | P4_R (13px regular), text-tertiary (#08) | Relative when <24h, date otherwise |
| Unread indicator | Left edge | — | Small dot, primary color (#02) |
| Smart Label | Right or below subject | Label component | e.g. "Action required", "FYI" |

### Spacing

- Row height: auto, minimum ~72px
- Internal padding: 16px horizontal (space-4), 12px vertical (space-3)
- Gap between rows: 0 (separated by standard divider, 0.5px, color #08)
- Avatar size: 40×40px, pill radius

### States

| State | Visual Treatment |
|-------|-----------------|
| Unread | Bold sender name + blue dot on left edge |
| Read | Regular weight sender name, no dot |
| Selected | Background overlay-light (#14) |
| Hover (Desktop) | Background overlay-subtle (#16) |
| Swiped (iOS/Android) | Reveal action buttons behind row |

---

## Smart Labels

AI assigns labels automatically based on email content and intent:

| Label | Color | Meaning |
|-------|-------|---------|
| Action required | Red (#11) | User needs to do something |
| FYI | Blue (#02) | Informational, no action needed |
| Waiting on others | Yellow (#12) | Ball is in someone else's court |
| Low priority | Gray (#25) | Can be deferred or ignored |

Labels use the Label component (8×4 padding mobile, 10×6 desktop, P4_B 13px bold, radius pill).

---

## Interactions

### Tap / Click

Opens the email detail view with auto-summary at the top.

### Swipe (iOS / Android)

| Direction | Action | Icon | Color |
|-----------|--------|------|-------|
| Left short | Archive | `archive` | Primary (#02) |
| Left long | Delete | `delete` | Error (#11) |
| Right short | Mark unread/read | `unread` / `read` | Neutral (#25) |

### Long-press (iOS / Android)

Opens context menu with: Reply, Forward, Archive, Delete, Mark as read/unread, Label, Snooze.

### Right-click (Desktop)

Same context menu as long-press.

### Bulk Select

- iOS/Android: Long-press a row to enter selection mode, tap others to add.
- Desktop: Checkbox appears on hover at left edge; Shift+click for range.

---

## Platform-Specific Notes

### Desktop (Electron + React + Radix UI)

- Three-pane layout: sidebar → email list → email detail.
- Hover state on rows.
- Keyboard navigation: arrow keys to move, Enter to open, Delete/Backspace to archive.
- Use Radix `ContextMenu` for right-click.

### iOS (Swift / SwiftUI)

- Full-width list, push navigation to detail.
- Swipe actions via `swipeActions` modifier.
- Long-press via `.contextMenu`.
- Support Dynamic Type for accessibility font sizing.
- Dark mode: use token dark values.

### Android (Kotlin)

- Full-width list with `LazyColumn` or `RecyclerView`.
- Swipe actions via `SwipeToDismiss` (Compose) or `ItemTouchHelper` (Views).
- Long-press context menu.
- System back button returns from detail to list.
- Material Design 3 integration where appropriate, but Filo visual tokens take priority.

---

## Empty State

When the inbox is empty:

- Centered illustration (calm, minimal)
- Headline: "You're all caught up"
- Subtext: "Nice work. Go do something that matters."
- No confetti, no celebration animation
