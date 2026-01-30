# Filo Design Guidelines

This folder contains the visual design system for Filo.

## Structure

```
Design Guidelines/
├── Colors/
│   └── colors.json           # Color palette with light/dark variants
├── Typography/
│   └── typography.json       # Type scale and font specifications
├── Icons/
│   └── icons.json            # Icon system guidelines
├── Components/
│   └── components.json       # UI component specifications
└── Screens/
    └── sign-in-screen.json   # Sign-in/launch screen specifications
```

---

## Visual Direction

- Clean, modern UI
- Soft colors, controlled contrast
- Minimal ornamentation
- Motion only when it clarifies meaning
- No visual noise disguised as delight

The interface should feel: stable, predictable, trustworthy, lightweight.

---

## App Icon

The Filo app icon features a blue gradient background with a white speech bubble containing a checkmark — representing email clarity and task completion.

**Source file:** `Resources/AppIcon-combined.svg`

**Design elements:**
- Rounded square with ~26.8% corner radius
- Gradient: `#9DDEFF` (top) → `#22A0FB` (20%) → `#0D93F3` (bottom)
- White speech bubble with checkmark overlay

**Export sizes for Xcode:**

| Platform | Size | Scale | Filename |
|----------|------|-------|----------|
| iOS | 1024×1024 | 1x | `AppIcon-iOS.png` |
| macOS | 16×16 | 1x, 2x | `AppIcon-16.png`, `AppIcon-16@2x.png` |
| macOS | 32×32 | 1x, 2x | `AppIcon-32.png`, `AppIcon-32@2x.png` |
| macOS | 128×128 | 1x, 2x | `AppIcon-128.png`, `AppIcon-128@2x.png` |
| macOS | 256×256 | 1x, 2x | `AppIcon-256.png`, `AppIcon-256@2x.png` |
| macOS | 512×512 | 1x, 2x | `AppIcon-512.png`, `AppIcon-512@2x.png` |

Export PNGs from Figma or the SVG source, then add to `Resources/Assets.xcassets/AppIcon.appiconset/`.

---

## Brand Personality

Filo's personality is: calm, clear, thoughtful, slightly opinionated, never loud.

The product should feel like:
> A smart, composed assistant who knows when to speak and when to stay quiet.

---

## Copy & Voice

- Short sentences
- Plain language
- No hype words
- No "AI magic" claims

Good copy answers:
- What is happening?
- Why does it matter?
- What should I do next?

The tone in **The Start of Filo** — grounded, human, slightly self-aware — should carry through all UI and UX copy. Write like a thoughtful person, not a product.
