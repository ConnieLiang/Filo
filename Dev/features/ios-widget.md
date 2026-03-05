# Feature Spec: Filo iOS Home Screen Widget

Medium-sized home screen widget for Filo iOS. Surfaces at-a-glance info (unread important count, latest todo) and one-tap compose. Calm, scannable, and aligned with Apple's Widget guidelines.

**References:**
- [Apple HIG: Widgets](https://developer.apple.com/design/human-interface-guidelines/widgets/)
- [SwiftUI: Widget](https://developer.apple.com/documentation/swiftui/widget)
- **Design tokens:** `Dev/tokens.json`
- **Icons:** `Resources/Icons/Library/` (see icons.json)

---

## Requirements (from feature request)

| Requirement | Implementation |
|-------------|----------------|
| Display latest todo | One primary todo line (or “No tasks” empty state) |
| Numbers of unread important emails | Prominent count next to Important / inbox icon |
| Compose email directly | Tappable compose control that opens app to compose |
| Widget size | **Medium** only (this spec) |
| Follow Apple's Guidelines | See Compliance section below |

---

## Widget Size: Medium

- **System size:** Use `WidgetFamily.systemMedium`.
- **Approximate dimensions:** ~364×170 pt (device-dependent; use SwiftUI layout, not fixed pt).
- Single configuration for this spec; small/large can be added later if needed.

---

## Layout (Medium)

Layout is inspired by common email widgets (e.g. Spark, Gmail) but uses Filo tokens and only the three requested elements. No decorative clutter.

```
┌─────────────────────────────────────────────────────────┐
│  [envelope icon]   [Unread important count]    [compose]  │  ← Top row: icon + count (left), compose (right)
│       (primary)         e.g. "12"                        │
│                                                          │
│  ─────────────────────────────────────────────────────  │  ← Divider (token 08)
│                                                          │
│  Latest todo line (one line, truncate with …)            │  ← P2_R or P3_R, single line
│  or "No tasks" / "Nothing due" if empty                  │
│                                                          │
│  ─────────────────────────────────────────────────────  │
│                                                          │
│  [Email 1] Sender · Subject…            Date              │  ← Optional: 1–2 recent important emails
│  [Email 2] Sender · Subject…            Date              │     (same style as list in app)
└─────────────────────────────────────────────────────────┘
```

**Priority order for content:**
1. Unread important count + compose (always visible).
2. Latest todo (one line; empty state if none).
3. Optional: up to 2 latest “important” email previews (sender, subject truncated, date) for density. If data or space is limited, omit and keep only count + todo.

---

## Design Tokens (from Dev/tokens.json)

| Use | Token | Value (light) |
|-----|--------|----------------|
| Background | 10-background | #FFFFFF |
| Text primary | 06-text-primary | #000000 |
| Text secondary | 07-text-secondary | #707070 |
| Text tertiary | 08-text-tertiary | #999999 |
| Divider | 08-text-tertiary or 14-overlay-light | #999999 / rgba(0,0,0,0.04) |
| Primary (count, compose accent) | 02-primary | #22A0FB |
| Surface (optional row bg) | 09-surface-tertiary | #F5F5F5 |

**Typography (widget-appropriate):**
- Unread count: **P2_B** or **P1.1_B** (16–17 pt, bold).
- Todo line / email subject: **P2_R** or **P3_R** (15–16 pt regular).
- Date / meta: **P4_R** (13 pt).
- Empty state (“No tasks”): **P3_R**, color **07-text-secondary**.

**Spacing:** Use `space-2` (8) to `space-4` (16) for internal padding and gaps; align with existing list/card padding where possible.

**Radius:** Widget container uses system corner radius; internal elements (e.g. compose button) use **radius-1** (16) or pill if single-line.

---

## Icons (Filo library)

| Purpose | Icon name | Source |
|---------|-----------|--------|
| Important / Inbox (with count) | `inbox-before` or `envelope` | Resources/Icons/Library/Property 1=*.svg |
| Compose | `compose` | Same |
| Todo (if shown next to todo line) | `todo` | Same |

Export SVGs to **@1x, @2x, @3x** PNGs for the widget extension target and add to `FiloApp/Assets.xcassets/` (or widget-specific asset catalog). Use template rendering so tint (e.g. primary blue) applies.

---

## Copy

| Context | Copy (English) |
|---------|----------------|
| Unread important | Show number only (e.g. `12`). No “unread” label if space is tight; icon + number is sufficient. |
| Empty todo | “No tasks” or “Nothing due” |
| Compose | No label required; icon only. Accessibility: “Compose email” or “New email”. |
| Email row | Sender name (bold) · Subject (truncated) — Date (e.g. “Feb 20” or “7:20 AM”) |

---

## Deep Links / Actions

| Control | Behavior |
|---------|----------|
| Compose button | Open app into **compose** (new message). Use WidgetKit URL or app URL scheme that the app handles. |
| Unread count / envelope | Open app to **Important** or **Inbox** filtered to important. |
| Todo line | Open app to **To-do** tab or the specific task if supported. |
| Email row (if present) | Open app to that **email’s thread**. |

Implement via `widgetURL` / `Link` in SwiftUI and handle in the main app.

---

## Apple Guidelines Compliance

- **Relevance:** Widget shows only useful, up-to-date info (unread count, one todo, optional recent emails). No vanity metrics. *(Filo: Reduce cognitive friction.)*
- **Clarity:** One primary number (unread important), one primary action (compose), one todo line. No overcrowding. *(Filo: Scanning > reading.)*
- **Consistency:** Use system widget container; interior uses Filo tokens and SF Pro so it feels native but on-brand.
- **Respect system:** Support Dynamic Type where applicable; avoid tiny fixed font sizes. Prefer semantic colors (e.g. primary for actionable elements) and support appearance (light/dark) via tokens.
- **No misleading urgency:** Unread count is factual; avoid “99+” unless product rule is to cap. *(Filo: Respect attention.)*

Reference [Human Interface Guidelines – Widgets](https://developer.apple.com/design/human-interface-guidelines/widgets/) and [SwiftUI Widget](https://developer.apple.com/documentation/swiftui/widget) for:
- Widget family and size
- Timeline provider and refresh policy
- Accessibility labels and widget URL handling

---

## Data and Refresh

- **Unread important count:** From app’s sync/model (e.g. “Important” or equivalent filter). Refresh on timeline (e.g. every 15–30 min or when app foregrounds).
- **Latest todo:** Single “next” or “most relevant” task from app’s todo model; same refresh strategy.
- **Recent emails (optional):** Up to 2 from Important or Inbox; same source as list in app.

Prefer a shared container (App Group) so the widget extension can read the same data the app uses, without duplicating network logic in the extension.

---

## Platform Notes (iOS)

- **Repo:** Filo iOS (Swift/SwiftUI).
- **Implementation:** New Widget Extension target; use `WidgetKit` and SwiftUI. No Figma; implement from this spec and tokens.

---

## Developer handoff

### Required materials (in repo)

| Item | Location |
|------|----------|
| This spec | `Dev/features/ios-widget.md` |
| Design tokens | `Dev/tokens.json` |
| Icon library (SVG) | `Resources/Icons/Library/` |
| Icon index | `Design Guidelines/Icons/icons.json` |
| iOS platform notes | `Dev/platform-notes/ios.md` |
| Design principles | `Dev/principles.md` |

### Assets to generate

Export from Filo’s SVG library at **@1x, @2x, @3x** PNG. Add to `FiloApp/Assets.xcassets/` (or widget extension catalog) with **Render As: Template Image**.

| Asset | Source SVG | Catalog name |
|-------|------------|--------------|
| Envelope / Inbox | `Property 1=inbox-before.svg` or `Property 1=envelope.svg` | `iconEnvelope` |
| Compose | `Property 1=compose.svg` | `iconCompose` |
| Todo (optional) | `Property 1=todo.svg` | `iconTodo` |

Export at 24×24 pt (or 44×44 for compose button); tint with 02-primary in SwiftUI.

### Implementation checklist

- [ ] Create **Widget Extension** target (SwiftUI, WidgetKit).
- [ ] Implement **medium** only (`WidgetFamily.systemMedium`).
- [ ] **Timeline provider:** Unread important count, latest todo, optional 2 recent emails (from App Group).
- [ ] **UI:** Top row = envelope + count (left), compose (right). Divider. One todo line or “No tasks”. Optional 1–2 email rows.
- [ ] **Tokens:** Map `tokens.json` to SwiftUI; support light/dark.
- [ ] **Deep links:** Compose → compose; count → Important; todo → To-do; email row → thread.
- [ ] **Accessibility:** “Compose email”; “X unread important emails”.
- [ ] **Refresh:** Timeline policy (e.g. 15–30 min or on app foreground).
- [ ] **Assets:** 1x/2x/3x PNGs, Template Image.

### Data (App Group)

| Data | Type | Notes |
|------|------|--------|
| Unread important count | `Int` | From Important filter |
| Latest todo | `String?` or `{ title, id }` | `nil` → “No tasks” |
| Recent emails (optional) | Up to 2 × (sender, subject, date, threadId) | For optional rows |

App writes to shared container; widget reads on timeline.

### Reference (design intent)

Spark/Gmail references: Filo widget is **simpler** — unread **important** count (not all inbox), **one** todo line, **one** compose. Optional 1–2 email rows; no avatars or extra actions. Clarity and Filo principles first.
