---

## name: filo-design
description: Filo design system for AI agents. Enforces Filo tokens, components, and interaction patterns when generating UI code for Desktop, iOS, or Android. Use this skill when anybody asks to build new features. Generates creative, polished code that avoids generic AI aesthetics.

# Filo Design Skill

Build production-grade Filo interfaces that look and feel like Filo — not like a template.

## Before Coding

1. **Read `tokens.json`** — every color, font, spacing, and radius value lives here. Never invent values.
2. **Read `principles.md`** — understand what Filo values before making visual decisions.
3. **Read the feature spec** in `/features/` if one exists for the feature being built.
4. **Read the platform note** in `/platform-notes/` for the target platform.

Do this every time. Do not skip it even if you think you know the values.

## Filo's Aesthetic

Filo looks like: **calm, clean, stable, trustworthy, lightweight.**

- Soft colors, controlled contrast — not flat white with bright accents
- Generous spacing — content breathes
- Rounded shapes — radius starts at 16px, single-line elements use pill (999)
- Typography has weight hierarchy — bold for what matters, regular for the rest, tertiary for timestamps
- Dividers are 0.5px and nearly invisible — they organize, not decorate
- Motion only when it clarifies transitions — no bounce, no spring, no confetti
- Copy is short, native, English first — plain language, no hype

## Color Rules

All colors come from `Dev/tokens.json`. There are 25 tokens, each with light and dark values.


| Role           | Token | Light     | Dark      |
| -------------- | ----- | --------- | --------- |
| Brand primary  | `02`  | `#22A0FB` | `#45B1FF` |
| Background     | `10`  | `#FFFFFF` | `#1D1D21` |
| Surface        | `09`  | `#F5F5F5` | `#2A2A30` |
| Text primary   | `06`  | `#000000` | `#FFFFFF` |
| Text secondary | `07`  | `#707070` | `#8B8B8B` |
| Text tertiary  | `08`  | `#999999` | `#414149` |
| Error          | `11`  | `#E53935` | `#BE424D` |
| Success        | `18`  | `#7EBA02` | `#7EBA02` |


- **Never hardcode colors.** Use CSS variables (`var(--filo-02)`), SwiftUI Color assets, or Android color resources.
- **Both modes are mandatory.** Every screen must work in light and dark.
- **Overlays are subtle.** Hover = `rgba(0,0,0,0.02)`, selection = `rgba(0,0,0,0.04)`. Not gray backgrounds.

## Typography Rules

Primary font: **SF Pro** (Apple), **Roboto** (Android), **Segoe UI** (Windows).

Key styles used most often:


| Style | Weight        | Size | Use                           |
| ----- | ------------- | ---- | ----------------------------- |
| P2_B  | Bold (700)    | 16px | Sender names, emphasized body |
| P2_R  | Regular (400) | 16px | Standard body text            |
| P3_R  | Regular (400) | 15px | Secondary text, previews      |
| P4_R  | Regular (400) | 13px | Timestamps, captions          |
| P4_B  | Bold (700)    | 13px | Labels, badges                |
| H5    | Bold (700)    | 22px | Section headers               |


Full scale (20 styles from H1 40px to P5 10px) is in `Dev/tokens.json` under `typography.styles`.

- **Letter spacing is negative** for body text (-0.2px). This is intentional — it makes SF Pro feel tighter and calmer.
- **Never use generic fonts.** No Inter, no Arial, no system-ui as a primary choice.

## Spacing and Radius

Spacing scale: 4 → 8 → 12 → 16 → 20 → 30 → 40 px.


| Context        | Value      |
| -------------- | ---------- |
| Icon padding   | 4px        |
| Button padding | 16×8 (h×v) |
| Card padding   | 16px       |
| List item gap  | 12px       |
| Section gap    | 20px       |
| Page margin    | 20px       |


Radius: 16 (buttons, inputs) → 20 (cards) → 24 (sheets) → 30 (hero cards) → 999 (pills, tags, single-line cells).

**Rule:** Single-line content cells always use pill radius (999). Multi-line cells use 16 or 20.

## Component Patterns

### Buttons

- Pill shape: `border-radius: 100` (not 999 — buttons use their own spec)
- Sizes: small (h:12 v:8, 15px), medium (h:30 v:12, 15px), large (h:34 v:16, 15px, 350px width)
- Variants: outlined, ghost, tinted, filled, filledBlack
- States: default → hover (opacity 0.9) → pressed (opacity 0.8, scale 0.98) → disabled (opacity 0.5)

### Labels

- Mobile: 8×4 padding, 13px bold (P4_B), pill radius
- Desktop: 10×6 padding, 15px bold, pill radius
- Colors: blue, green, yellow, red, purple, cyan, gray — each maps to a token

### Cards

- Summary, todo, tracker, AI-action, tips, spam card types
- Width: 350px, radius 24px (multi-line) or 999 (single-line/pill)
- Padding: 16px outer, 10px inner sections
- Background: `--filo-05` (blue tint) or `--filo-14` (gray tint)

### Dividers

- Standard: 0.5px, color `--filo-08` — between list items and sections
- Subtle: 0.5px, color `--filo-14` — frame edges for depth separation

For full component specs, read `/Components/`.

## Platform-Specific Implementation

### Desktop (React + Radix UI + Tailwind)

- Map Filo tokens to Tailwind via CSS custom properties in `theme.extend`
- Use Radix UI primitives (Dialog, ContextMenu, DropdownMenu, Tooltip)
- Icons: SVG imports from `Resources/Icons/Library/`
- Three-pane layout: sidebar → list → detail
- Keyboard navigation is mandatory (arrow keys, Enter, Cmd+Enter to send)
- Read `Dev/platform-notes/desktop.md` for full details

### iOS (SwiftUI)

- Use native `NavigationStack`, `.sheet`, `.alert`, `.contextMenu`
- iOS 26+: use Apple's `.glassEffect()` for navigation bars — do not recreate manually
- Swipe actions via `.swipeActions`, context menus via `.contextMenu`
- Define all colors in `Assets.xcassets` with light/dark variants
- Support Dynamic Type via `@ScaledMetric`
- Min touch target: 44×44pt
- Read `/platform-notes/ios.md` for full details

### Android (Kotlin / Jetpack Compose)

- Define colors in `res/values/colors.xml` + `res/values-night/colors.xml`
- Use `sp` units for text (respects user font scaling)
- Handle system back explicitly via `BackHandler`
- Filo tokens override Material You — do not rely on dynamic color
- Min touch target: 48×48dp
- Read `/platform-notes/android.md` for full details

## What Filo UI Never Does

- **No generic Tailwind/Material defaults.** No `bg-gray-100`, no `text-slate-600`, no `rounded-lg` without mapping to a Filo token.
- **No decorative animation.** No bounce, no spring, no parallax, no confetti, no loading spinners that dance. Motion is functional.
- **No attention-grabbing patterns.** No red badge counts without justification, no pulsing elements, no "new!" badges, no fake urgency.
- **No visual clutter.** If an element doesn't help the user decide or act, remove it.
- **No invented values.** Every color, size, and spacing must trace back to `Dev/tokens.json`. If a value isn't in the token system, ask — don't improvise.

## AI Feature Visibility

Filo is AI-first. AI capabilities should be visible where they create value:

- **Summaries** appear at the top of email detail — prominent, not collapsed
- **Smart labels** are shown on every email row — front and center
- **Instant Write** suggests drafts automatically on reply — no prompt required
- **Task extraction** surfaces action items inline — not in a separate panel

The AI earns trust through results. Show what it did, let users correct it. No "powered by AI" badges, no sparkle icons, no branding. The product *is* the AI.

## Icons

Source: `Resources/Icons/Library/`, naming: `Property 1={icon-name}.svg`

- Default size: 24×24px
- Stroke: 1.5–2px, outline style, rounded corners
- Use `currentColor` for theming
- State pairs exist (e.g., `star-before`/`star-after`, `inbox-before`/`inbox-after`)
- Full icon inventory is in `Design Guidelines/Icons/icons.json`

## Issue & Design Review

When responding to GitHub issues or design proposals, apply the following principles.

### Stance

Do not blindly approve. Do not blindly reject. Give an honest, specific assessment — acknowledge what works, and clearly flag what needs to change and why. Every piece of feedback should be actionable.

### Copy Naming

Check all labels, group titles, and button text against Filo's copy principles: short, plain, no explanation. If a name is longer than it needs to be, call it out. Example: "AI Features" → "AI".

### UX Consistency

Flag any place where different interaction patterns are mixed without visual distinction. Specifically:
- External links and internal navigation pages must not appear as identical list items
- If an item opens a new page, a modal, or an external URL — the affordance must be different
- Mixing these without differentiation violates user expectation and breaks trust

### New Feature Evaluation

If a proposal introduces a new feature (not just restructuring existing UI), evaluate its value before reviewing implementation details:
- Is this solving a real, frequent user pain point?
- Is there evidence this is needed, or is it hypothetical?
- What is the cost (dev complexity, surface area, maintenance)?

If the value isn't established, say so — do not proceed to detailed design feedback as if the feature is already approved.

### Comment Format

When posting a review comment as Design Agent:
- Open with an overall verdict (support / concerns / blocking issues)
- Group feedback by topic with clear headers
- Be specific — reference Filo principles, token names, or UX laws where relevant
- End with a clear next step (what needs to be resolved before moving forward)

---

## Checklist Before Finishing

- Every color references a Filo token — no hardcoded hex values
- Light and dark mode both work
- Typography uses the Filo scale — no arbitrary font sizes
- Spacing follows the 4/8/12/16/20/30/40 scale
- Radius follows the token system (16/20/24/30/999)
- Interactive elements meet minimum touch targets (44pt iOS, 48dp Android)
- No generic framework defaults leaked through (Tailwind gray-*, Material default purple, etc.)
- The interface feels calm — nothing competes for attention

