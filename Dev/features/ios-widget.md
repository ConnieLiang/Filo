# Feature Spec: Filo iOS Home Screen Widgets

Filo's home screen widgets let people check what matters and start writing without opening the app — so email stays useful without demanding attention.

**Sizes:** Small, Medium, Large  
**Prototype:** `filo-ios/FiloWidget/FiloWidget.swift`

**References:**
- [Apple HIG: Widgets](https://developer.apple.com/design/human-interface-guidelines/widgets/)
- [SwiftUI: Widget](https://developer.apple.com/documentation/swiftui/widget)
- **Design tokens:** `Dev/tokens.json`
- **Icons:** `Resources/Icons/Library/` (see icons.json)

---

## Small Widget (~170×170 pt)

Todo list only. Entire widget taps to To-do tab.

```
┌──────────────────────┐
│  📋 To-do  4         │
│  ────────────────    │
│  ☐  Review NDA f…    │
│  ☐  Submit expen…    │
│  ☐  Reply to Sar…    │
└──────────────────────┘
```

### Layout

| Element | Spec |
|---------|------|
| Title row | Todo icon (18×18, 02-primary) + "To-do" (P2_B) + count (P4_R, 07-text-secondary) |
| Divider | 0.5pt, 14-overlay-light |
| Todo rows | Up to **3**. Checkbox (SF Symbol `square`, 14pt, 08-text-tertiary) + title (P4_R, 06-text-primary, 1 line) + optional date (P4_R, 08-text-tertiary or 02-primary if "Today") |
| Padding | 16pt all sides |

### Interaction

| Tap target | Behavior |
|------------|----------|
| Entire widget | Open app → **To-do** tab |

---

## Medium Widget (~364×170 pt)

Two-column layout. Todo list on the left, blue action panel on the right.

```
┌──────────────────────────────────────────────────────┐
│                                    ┌───────────────┐ │
│  📋 To-do  4                       │   ✉ (white)   │ │
│  ─────────────────────             │      12       │ │
│  ☐  Review NDA from Legal  Today   │───────────────│ │
│  ☐  Submit expense report          │   ✏ (white)   │ │
│  ☐  Reply to Sarah's pro…  Mar 7   │   Compose     │ │
│                                    └───────────────┘ │
└──────────────────────────────────────────────────────┘
         Column 1 (todos)           Column 2 (actions)
                    ← 16pt gap →
```

### Column 1 — Todo list

| Element | Spec |
|---------|------|
| Title row | Todo icon (18×18, 02-primary) + "To-do" (P2_B) + count (P4_R, 07-text-secondary) |
| Divider | 0.5pt, 14-overlay-light |
| Todo rows | Up to **3**. Same spec as small widget. |
| Padding | 16pt leading, 14pt vertical |

### Column 2 — Action panel (vertical)

Blue rounded rectangle (02-primary fill, 20pt continuous radius). 80pt wide, 8pt inset from top/right/bottom edges.

| Element | Spec |
|---------|------|
| **Inbox (top half)** | Envelope icon (22×22, white) + unread count (P1.1_B 17pt bold, white) |
| **Divider** | 0.5pt, white (#10-background), 22pt horizontal padding |
| **Compose (bottom half)** | Compose icon (22×22, white) + "Compose" label (P5_R 10pt, white 90%) |

Gap between columns: **16pt**.

### Interactions

| Tap target | Behavior |
|------------|----------|
| Column 1 (entire todo column) | Open app → **To-do** tab |
| Inbox (panel top) | Open app → **Inbox** tab |
| Compose (panel bottom) | Open app → **Compose** screen |

---

## Large Widget (~364×382 pt)

Two-row layout. Horizontal action panel on top, todo list below.

```
┌──────────────────────────────────────────────────────┐
│  ┌────────────────────────────────────────────────┐  │
│  │  ✉  12          │          ✏  Compose          │  │
│  └────────────────────────────────────────────────┘  │
│                                                      │
│  📋 To-do  4                                         │
│  ────────────────────────────────────────────────    │
│  ☐  Review NDA from Legal                    Today   │
│  ☐  Submit expense report                            │
│  ☐  Reply to Sarah's proposal about the…    Mar 7    │
│  ☐  Book flight to SF for next week          Mar 10  │
│  ☐  Update project timeline                          │
│  ☐  Send invoice to client                   Mar 12  │
└──────────────────────────────────────────────────────┘
         Row 1 (actions)
         Row 2 (todos)
```

### Row 1 — Action panel (horizontal)

Blue rounded rectangle (02-primary fill, 20pt continuous radius). 52pt tall, 8pt inset from top and sides. 12pt gap below.

| Element | Spec |
|---------|------|
| **Inbox (left half)** | Envelope icon (22×22, white) + unread count (P1.1_B 17pt bold, white), horizontal layout, 8pt gap |
| **Divider** | 0.5pt wide, white, 16pt vertical padding |
| **Compose (right half)** | Compose icon (22×22, white) + "Compose" label (P4_R 13pt, white 90%), horizontal layout, 8pt gap |

### Row 2 — Todo list

| Element | Spec |
|---------|------|
| Title row | Todo icon (18×18, 02-primary) + "To-do" (P2_B) + count (P4_R, 07-text-secondary) |
| Divider | 0.5pt, 14-overlay-light |
| Todo rows | Up to **6**. Same row spec as small/medium. |
| Padding | 16pt horizontal, 14pt top |

### Interactions

| Tap target | Behavior |
|------------|----------|
| Todo section (row 2) | Open app → **To-do** tab |
| Inbox (panel left) | Open app → **Inbox** tab |
| Compose (panel right) | Open app → **Compose** screen |

---

## Empty State (all sizes)

When there are zero todos, the todo area shows centered:
- Checkmark circle icon (SF Symbol `checkmark.circle`, 20pt light, 08-text-tertiary)
- Daily-rotating copy (P3_R 15pt, 07-text-secondary)

| Day | Copy |
|-----|------|
| Sun | "You earned this quiet." |
| Mon | "Clean slate. Nice." |
| Tue | "Nothing here. You're ahead." |
| Wed | "All done. Go outside." |
| Thu | "Inbox zero energy." |
| Fri | "No tasks. Weekend's calling." |
| Sat | "Rest mode: on." |

---

## Checkbox Interaction (iOS 17+, all sizes)

- Use `Button` backed by `AppIntent` that marks the task done in the shared data store.
- On tap: swap to checked icon (tinted 02-primary), apply strikethrough + 08-text-tertiary color.
- After ~2 seconds, timeline reloads and the completed row disappears.
- Falls back to opening app on iOS 16.
- Accessibility: "Complete: [task name]".

---

## Design Tokens

| Use | Token | Light | Dark |
|-----|-------|-------|------|
| Widget background | System `.fill.tertiary` | (system) | (system) |
| Text primary | 06-text-primary | #000000 | #FFFFFF |
| Text secondary | 07-text-secondary | #707070 | #8B8B8B |
| Text tertiary | 08-text-tertiary | #999999 | #65656A |
| Divider (todos, title) | 14-overlay-light | rgba(0,0,0,0.08) | rgba(255,255,255,0.08) |
| Divider (action panel) | 10-background | #FFFFFF | #FFFFFF |
| Primary (panel bg, "Today") | 02-primary | #22A0FB | #45B1FF |
| Panel icons + text | 10-background | #FFFFFF | (white) |

### Typography

| Element | Token | Size | Weight |
|---------|-------|------|--------|
| "To-do" title | P2_B | 16pt | Bold (700) |
| Todo count | P4_R | 13pt | Regular (400) |
| Todo title | P4_R | 13pt | Regular (400) |
| Todo date | P4_R | 13pt | Regular (400) |
| Unread count (panel) | P1.1_B | 17pt | Bold (700) |
| "Compose" (medium, vertical) | P5_R | 10pt | Regular (400) |
| "Compose" (large, horizontal) | P4_R | 13pt | Regular (400) |
| Empty state copy | P3_R | 15pt | Regular (400) |

---

## Icons

| Purpose | Icon name | Rendering | Size |
|---------|-----------|-----------|------|
| Todo title | `todo` (Filo library) | Template, 02-primary | 18×18 pt |
| Inbox (panel) | `inbox-before` (Filo library) | Template, white | 22×22 pt |
| Compose (panel) | `compose` (Filo library) | Template, white | 22×22 pt |
| Checkbox | SF Symbol `square` | 14pt, 08-text-tertiary | — |
| Empty state | SF Symbol `checkmark.circle` | 20pt light, 08-text-tertiary | — |

Filo icons stored in widget asset catalog (`FiloWidget/Assets.xcassets/`).

---

## Widget Configuration

- **Families:** `.systemSmall`, `.systemMedium`, `.systemLarge`
- **Content margins:** Disabled via `.contentMarginsDisabled()`
- **Container background:** `.fill.tertiary` (system-provided)
- **Display name:** "Filo"
- **Description:** "Emails and tasks at a glance."
- Deep links: `filopreview://todo`, `filopreview://inbox`, `filopreview://compose`

---

## Shared Components

Reusable across all three sizes:

| Component | Used by |
|-----------|---------|
| `FiloTodoTitle` | Small, Medium, Large |
| `FiloTodoRow` | Small, Medium, Large |
| `FiloTodoList` (accepts `maxItems`) | Small (3), Medium (3), Large (6) |
| `FiloEmptyState` | Small, Medium, Large |
| `FiloActionPanel` (accepts `axis`) | Medium (`.vertical`), Large (`.horizontal`) |

---

## Data and Refresh

| Data | Type | Example |
|------|------|---------|
| Unread important count | `Int` | `12` |
| Todos | `[{ title, dueDate?, id }]` | Up to 6; sorted by relevance/due date |

- **App Group** shared container. App writes on sync; widget reads via `TimelineProvider`.
- Refresh: every 15–30 min, or on app foreground.
- Checkbox intent writes completion back; requests timeline reload.

---

## Apple Guidelines Compliance

- **Interactive widgets (iOS 17+):** Checkbox via `Button` + `AppIntent`.
- **Glanceable:** Small = todo only; Medium = todos + actions; Large = more todos + actions. No scrolling.
- **Content margins:** `.contentMarginsDisabled()` for edge-to-edge action panel.
- **Adaptive:** Light/dark via tokens. System container background.
- **No misleading urgency:** Count is factual. No red badges.

---

## Platform Notes (iOS)

- **Repo:** Filo iOS (Swift/SwiftUI).
- **Target:** Widget Extension (`FiloWidget`).
- **Minimum:** iOS 17+ (for `.contentMarginsDisabled()` and interactive widgets).
- **Prototype:** `filo-ios/FiloWidget/FiloWidget.swift`

---

## Developer Handoff

### Materials

| Item | Location |
|------|----------|
| This spec | `Dev/features/ios-widget.md` |
| Working prototype | `filo-ios/FiloWidget/FiloWidget.swift` |
| Design tokens | `Dev/tokens.json` |
| Icon library (SVG) | `Resources/Icons/Library/` |
| Widget asset catalog | `filo-ios/FiloWidget/Assets.xcassets/` |

### Assets (in widget catalog)

| Asset | Source SVG | Catalog name |
|-------|------------|--------------|
| Envelope | `Property 1=inbox-before.svg` | `iconEnvelope` |
| Compose | `Property 1=compose.svg` | `iconCompose` |
| Todo | `Property 1=todo.svg` | `iconTodo` |

### Checklist

- [x] Widget Extension target (`FiloWidget`).
- [x] All three sizes: `.systemSmall`, `.systemMedium`, `.systemLarge`.
- [x] Small: todo list only, entire widget taps to To-do.
- [x] Medium: two columns — todo list + vertical blue action panel.
- [x] Large: two rows — horizontal blue action panel on top + todo list below (up to 6).
- [x] Shared components: `FiloTodoTitle`, `FiloTodoRow`, `FiloTodoList`, `FiloEmptyState`, `FiloActionPanel`.
- [x] Empty state: daily-rotating friendly copy.
- [x] Typography: all Filo tokens.
- [x] Colors: adaptive light/dark from tokens.
- [x] Filo icons from asset catalog.
- [x] `.contentMarginsDisabled()` for edge-to-edge panel.
- [ ] Deep links: wire to actual app navigation.
- [ ] Checkbox `AppIntent` (iOS 17+): mark done, strikethrough, reload timeline.
- [ ] App Group shared container for live data.
- [ ] Timeline refresh: 15–30 min + on app foreground.
- [ ] Accessibility labels on all interactive elements.
