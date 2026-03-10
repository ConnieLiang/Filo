# Filo Icons

**Source of truth:** All Filo product icons live here in **filo-design**. Apps (iOS, macOS, Android, desktop) consume from this repo or from a synced copy.

- **Location:** `resources/icons/`
- **Format:** SVG
- **Naming:** `{icon-name}.svg` (e.g. `inbox-before.svg`, `send-email.svg`)
- **Catalog:** `icons.json` (categories, state variants, path template)

## Usage in apps

- **HTML:** `<img src="resources/icons/inbox-before.svg" alt="Inbox">`
- **SwiftUI:** Load from bundle; use `.renderingMode(.template)` and design tokens for color.
- **React/Web:** Import SVG or use path; `currentColor` for theming.

## Adding or changing icons

1. Export from Figma (SVG) or add new SVG to `resources/icons/`.
2. Name file `{kebab-case-name}.svg`.
3. Update `icons.json`: add to the right category and, if needed, to `stateVariants`.
4. Commit in filo-design; downstream apps sync or copy as needed.

## Guidelines

- **Size:** Default 24×24px; scale proportionally.
- **Color:** Use `currentColor` in SVG so apps can tint with design tokens.
- **Style:** Outline, consistent stroke weight (e.g. 1.5–2px).

See **Design Guidelines** (in main Filo repo or linked from filo-design) for full icon system.
