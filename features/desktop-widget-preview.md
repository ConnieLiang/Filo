# Feature: Desktop Widget Preview (Small, Medium, Large)

**Feature location:** [Filo Design → features](https://github.com/FiloAI/filo-design/tree/main/features) — this spec lives there with other feature docs.

Developer handoff for the Filo Desktop widget preview — use this to implement the native macOS/Windows widget or to extend the in-app preview.

---

## What’s included

- **In-app preview** of all three Apple widget sizes (Small, Medium, Large) in the Filo Desktop Electron app.
- **Layout and tokens** aligned with [ios-widget.md](ios-widget.md) and [desktop-widgets.md](desktop-widgets.md).
- **Shared `TodoRow`** and constants so a native WidgetKit implementation can mirror the same specs.

---

## Where it lives

All links below point to **[Filo Design / features](https://github.com/FiloAI/filo-design/tree/main/features)** (`FiloAI/filo-design`, `features/` on `main`).

| Item | Path |
|------|------|
| **This feature doc** | [features/desktop-widget-preview.md](https://github.com/FiloAI/filo-design/blob/main/features/desktop-widget-preview.md) |
| Widget preview page | [filo-desktop/src/pages/widget-preview.tsx](https://github.com/FiloAI/filo-design/blob/main/features/filo-desktop/src/pages/widget-preview.tsx) |
| Route | `/widget-preview` (see [filo-desktop/src/router/routes/index.ts](https://github.com/FiloAI/filo-design/blob/main/features/filo-desktop/src/router/routes/index.ts)) |
| Entry from app | Login page: "Preview widget" link (Electron only; see [filo-desktop/src/pages/login.tsx](https://github.com/FiloAI/filo-design/blob/main/features/filo-desktop/src/pages/login.tsx)) |
| Specs | [ios-widget.md](https://github.com/FiloAI/filo-design/blob/main/features/ios-widget.md), [desktop-widgets.md](https://github.com/FiloAI/filo-design/blob/main/features/desktop-widgets.md) |
| Design tokens (source of truth) | [Dev/tokens.json](https://github.com/FiloAI/filo-design/blob/main/features/Dev/tokens.json), [filo-desktop/design/tokens.json](https://github.com/FiloAI/filo-design/blob/main/features/filo-desktop/design/tokens.json) |
| Preview runbook | [preview-desktop.md](https://github.com/FiloAI/filo-design/blob/main/features/preview-desktop.md) |

---

## How to run the preview

From repo root (or from `filo-desktop`):

```bash
cd filo-desktop && pnpm install && pnpm electron:dev
```

Then in the Filo Desktop window: use **"Preview widget"** on the login screen, or navigate to `#/widget-preview`.

---

## Widget sizes (Apple HIG)

| Size | Dimensions (pt) | Content |
|------|-----------------|--------|
| **Small** | 170×170 | Todo list only (up to 3). 16pt padding. |
| **Medium** | 364×170 | Todo list (left) + vertical action panel (Inbox count + Compose, 76pt wide, 5pt inset). 16pt gap between columns. |
| **Large** | 364×382 | Todo list (top, up to 6) + horizontal bottom panel (Inbox + Compose, #14 fill). Panel: 64pt tall, 6pt inset sides/bottom, 24pt radius, 12pt gap above. |

---

## Layout constants (from `widget-preview.tsx`)

Use these when implementing the native widget so layout matches the preview.

**Small**  
- Padding: 16pt all sides. Container radius: 28pt.

**Medium**  
- Column 1: padding 16pt leading, 14pt vertical. Panel: 76pt wide, radius 24pt, inset 5pt. Gap between columns: 16pt.

**Large**  
- Todo section: 16pt horizontal padding, 14pt top. Bottom panel: height 64pt, radius 24pt, inset 6pt (sides and bottom). Gap above panel: 12pt. Inbox/Compose: vertical stack (icon above label), 2px gap; inbox icon 24×24; divider between Inbox and Compose: 24pt-tall vertical line (#14 / overlayLight).

**Todo rows**  
- Small/Medium: compact spacing (`py-2`). Large: `py-3`. Checkbox 14×14, 4px margin-right. Title 14pt, date 12pt; "Today" = primary, other dates = textSecondary. First row: -4pt marginTop for alignment.

---

## Data contract (same as iOS)

```ts
interface WidgetData {
  unreadImportantCount: number;
  todos: Array<{ id: string; title: string; dueDate?: string }>;
}
```

Max todos: Small/Medium = 3, Large = 6.

---

## Tokens and dark mode

- **Preview today:** Uses a local light-only token object in `widget-preview.tsx`. It does **not** read from `Dev/tokens.json` and does **not** switch for dark mode.
- **Native widget (spec):** Must use Filo tokens from `Dev/tokens.json` (or platform equivalent) with **adaptive light/dark** per [desktop-widgets.md](desktop-widgets.md) and [ios-widget.md](ios-widget.md).

Implement the real macOS widget with WidgetKit + SwiftUI and resolve colors from the token file by color scheme so the widget follows system light/dark.

---

## Next steps for implementation

1. **Native macOS widget:** Add a WidgetKit extension (companion app or future native app). Reuse layout and token semantics from this preview; render with SwiftUI and `Dev/tokens.json` (light/dark).
2. **Windows:** Use the same data contract and copy; map layout to the Widget Provider / Adaptive Cards per [desktop-widgets.md](desktop-widgets.md).
3. **Preview dark mode (optional):** If desired, wire the preview to `Dev/tokens.json` or app CSS variables so the preview also switches with theme.

---

## References

- [Apple HIG: Widgets](https://developer.apple.com/design/human-interface-guidelines/widgets/)
- [ios-widget.md](ios-widget.md) — Small / Medium / Large layout and tokens
- [desktop-widgets.md](desktop-widgets.md) — macOS/Windows strategy and data contract
