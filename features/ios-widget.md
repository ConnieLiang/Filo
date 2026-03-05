# Feature Spec: Filo iOS Home Screen Widget

Filo's home screen widget lets people check what matters and start writing without opening the app — so email stays useful without demanding attention.

**Size:** Medium (`WidgetFamily.systemMedium`)

**References:**
- [Apple HIG: Widgets](https://developer.apple.com/design/human-interface-guidelines/widgets/)
- [SwiftUI: Widget](https://developer.apple.com/documentation/swiftui/widget)
- **Design tokens:** `tokens.json` (repo root)
- **Icons:** `Resources/Icons/Library/` (see icons.json)

---

## Layout

Two-column layout. Left column is narrow (icon + count + compose). Right column fills remaining space (up to 3 todos).

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│   [inbox icon]     │  ☐  Review NDA from Legal      Mar 5     │
│       12           │  ──────────────────────────────────────   │
│                    │  ☐  Submit expense report                 │
│  ┌──────────┐      │  ──────────────────────────────────────   │
│  │ [compose] │      │  ☐  Reply to Sarah's proposal   Mar 7   │
│  │  (blue)  │      │                                          │
│  └──────────┘      │                                          │
│                                                                │
└────────────────────────────────────────────────────────────────┘
     Column 1                    Column 2
```

### Column 1 (left, ~80 pt wide)

| Element | Spec |
|---------|------|
| Inbox icon | `inbox-before` or `envelope`, tinted 02-primary (#22A0FB). ~24×24 pt. |
| Unread important count | Below icon. **P1.1_B** (17 pt bold), color 02-primary. |
| Compose button | Blue circle (02-primary fill, ~44×44 pt) with white `compose` icon (~20×20 pt). Bottom of column. |

Column 1 uses `VStack` with spacer between count area and compose button, vertically centered.

### Column 2 (right, fills remaining width)

Up to **3 todos**, separated by horizontal dividers (0.5 px, token 14-overlay-light).

Each todo row:

| Element | Spec |
|---------|------|
| Checkbox | `checkbox-unchecked` icon, 20×20 pt, color 08-text-tertiary. Leading edge. |
| Description | One line, truncated with `…`. **P3_R** (15 pt), color 06-text-primary. |
| Date (optional) | Trailing. **P4_R** (13 pt), color 08-text-tertiary. Only if the task has a due date. |

### Empty state (no todos)

When there are zero tasks, Column 2 shows a single line of **short, light, friendly copy** centered vertically. **P3_R**, color 07-text-secondary.

Rotate daily so the message feels alive. Examples:

| Day | Copy |
|-----|------|
| Mon | "Clean slate. Nice." |
| Tue | "Nothing here. You're ahead." |
| Wed | "All done. Go outside." |
| Thu | "Inbox zero energy." |
| Fri | "No tasks. Weekend's calling." |
| Sat | "Rest mode: on." |
| Sun | "You earned this quiet." |

Select by day-of-week (or hash of date) so it's deterministic, not random.

---

## Interactions

| # | Tap target | Behavior |
|---|------------|----------|
| 1 | **Inbox icon / count** | Open app → **Inbox** tab (Important filter if available). Use `Link` with deep link URL. |
| 2 | **Compose button** | Open app → **Compose** (new message). Use `Link` with deep link URL. |
| 3 | **Todo section** (background of Column 2) | Open app → **To-do** tab. Use `Link` wrapping the entire column. |
| 4 | **Individual todo checkbox** | Toggle: checked icon + strikethrough → hold 2 s → row disappears. See below. |

### Checkbox interaction (iOS 17+ interactive widgets)

Apple supports **`Button` and `Toggle` in widgets via AppIntents** (iOS 17+). This means the checkbox can work directly in the widget without opening the app.

**Implementation:**
- Use a `Button` (or `Toggle`) backed by an `AppIntent` that marks the task as done in the shared data store.
- On tap:
  1. Immediately swap icon to `checkbox-checked` (tinted 02-primary).
  2. Apply `strikethrough` + color 08-text-tertiary to the description text.
  3. After ~2 seconds, the next timeline refresh removes the completed row and shows the next task (or empty state).
- The 2-second "stay" is visual only; the intent completes the task immediately. The widget timeline reloads after a short delay to update the view.
- If targeting < iOS 17, fall back to opening the app (same as interaction #3).

**Accessibility:** Label the checkbox as "Complete: [task name]".

---

## Design Tokens

| Use | Token | Light | Dark |
|-----|-------|-------|------|
| Widget background | 10-background | #FFFFFF | #1D1D21 |
| Text primary | 06-text-primary | #000000 | #FFFFFF |
| Text secondary | 07-text-secondary | #707070 | #8B8B8B |
| Text tertiary / date | 08-text-tertiary | #999999 | #414149 |
| Divider (between todos) | 14-overlay-light | rgba(0,0,0,0.04) | rgba(255,255,255,0.06) |
| Primary (count, compose bg) | 02-primary | #22A0FB | #45B1FF |
| Compose icon (on blue) | 10-background | #FFFFFF | #1D1D21 |

**Typography:**
- Unread count: **P1.1_B** (17 pt, 700).
- Todo description: **P3_R** (15 pt, 400).
- Todo date: **P4_R** (13 pt, 400).
- Empty state: **P3_R** (15 pt, 400), color 07-text-secondary.

**Spacing:** `space-3` (12) internal padding; `space-2` (8) gaps between todo rows and between icon elements.

**Radius:** Compose button uses **pill** (999). Widget container uses system radius.

---

## Icons

| Purpose | Icon name | Notes |
|---------|-----------|-------|
| Inbox | `inbox-before` or `envelope` | Template image, tinted 02-primary |
| Compose | `compose` | White on 02-primary circle |
| Checkbox (unchecked) | `checkbox-unchecked` | Template, tinted 08-text-tertiary |
| Checkbox (checked) | `checkbox-checked` | Template, tinted 02-primary |
| Todo (optional section label) | `todo` | Only if adding a section header |

Export SVGs → **@1x, @2x, @3x** PNG. Render As: **Template Image** in asset catalog.

---

## Data and Refresh

| Data | Type | Example |
|------|------|---------|
| Unread important count | `Int` | `12` |
| Todos | `[{ title, dueDate?, id }]` | Up to 3; sorted by relevance/due date |

- Use **App Group** shared container. App writes on sync; widget reads via `TimelineProvider`.
- Refresh policy: every 15–30 min, or when app enters foreground.
- Checkbox intent writes completion back to the same shared store; request timeline reload after.

---

## Apple Guidelines Compliance

- **Interactive widgets (iOS 17+):** Checkbox uses `Button` with `AppIntent`. Compliant — Apple explicitly supports this pattern for task-completion actions. [(Ref: HIG)](https://developer.apple.com/design/human-interface-guidelines/widgets/)
- **Relevance:** Shows only actionable info — unread count, upcoming tasks. No vanity metrics.
- **Glanceable:** Two-column layout, max 3 todo rows. Nothing to scroll, nothing to figure out.
- **Respect system:** Support Dynamic Type, light/dark via tokens, system widget container radius.
- **No misleading urgency:** Count is factual; no "99+", no red badges.

---

## Platform Notes (iOS)

- **Repo:** Filo iOS (Swift/SwiftUI).
- **Target:** New Widget Extension. Use `WidgetKit`, SwiftUI, and `AppIntents` (for checkbox).
- **Minimum:** iOS 17+ (for interactive widgets). If supporting iOS 16, checkbox falls back to open-app.

---

## Developer Handoff

### Materials

| Item | Location |
|------|----------|
| This spec | `features/ios-widget.md` |
| Design tokens | `tokens.json` |
| Icon library (SVG) | In main Filo repo: `Resources/Icons/Library/` |
| Icon index | In main Filo repo: `Design Guidelines/Icons/icons.json` |
| iOS platform notes | `platform-notes/ios.md` |
| Design principles | `principles.md` |

### Assets

| Asset | Source SVG | Catalog name | Size |
|-------|------------|--------------|------|
| Inbox | `Property 1=inbox-before.svg` | `iconInbox` | 24×24 pt |
| Compose | `Property 1=compose.svg` | `iconCompose` | 20×20 pt (inside 44×44 circle) |
| Checkbox unchecked | `Property 1=checkbox-unchecked.svg` | `iconCheckboxOff` | 20×20 pt |
| Checkbox checked | `Property 1=checkbox-checked.svg` | `iconCheckboxOn` | 20×20 pt |

Export @1x, @2x, @3x. Template Image.

### Checklist

- [ ] Widget Extension target (SwiftUI, WidgetKit).
- [ ] `WidgetFamily.systemMedium` only.
- [ ] Two-column layout: left = inbox icon + count + compose; right = up to 3 todos.
- [ ] Todo rows: checkbox + description (1 line) + optional date, separated by dividers.
- [ ] Empty state: daily-rotating friendly copy.
- [ ] Deep links: inbox → Inbox tab; compose → Compose; todo area → To-do tab.
- [ ] Checkbox `AppIntent` (iOS 17+): mark done, strikethrough, reload timeline after ~2 s.
- [ ] Tokens: colors, type, spacing from `tokens.json`. Light + dark.
- [ ] Accessibility labels on all interactive elements.
- [ ] Timeline refresh: 15–30 min + on app foreground.
- [ ] Assets: 4 icons, 1x/2x/3x, Template Image.
