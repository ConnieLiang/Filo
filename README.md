# filo-design

Design system and engineering specs for building Filo. Shared across Desktop, iOS, and Android.

## Structure

```
filo-design/
├── README.md              # This file
├── SKILL.md               # AI agent design skill — enforces Filo tokens when generating UI code
├── tokens.json            # Colors, typography, spacing, radius, dividers (all platforms)
├── principles.md          # Product design principles, visual direction, copy & voice
├── resources/             # Design assets (icons, illustrations) — source of truth for product UI
│   ├── README.md          # What lives here and why
│   ├── DESIGNER-WORKFLOW.md  # How designers add and maintain assets
│   ├── icons/             # SVG icons (naming: {name}.svg)
│   │   ├── icons.json     # Catalog and categories
│   │   └── *.svg
│   └── illustrations/     # Spot illustrations, empty states (planned)
├── features/              # Feature interaction specs
│   ├── email-list.md      # Email list — layout, smart labels, swipe/hover, per-platform notes
│   └── compose.md         # Compose — fields, Instant Write, tone controls, per-platform notes
└── platform-notes/        # Platform-specific engineering guidance
    ├── desktop.md         # Electron + React + Radix UI + Tailwind
    ├── ios.md             # Swift / SwiftUI (iOS 17+, Liquid Glass on iOS 26+)
    └── android.md         # Kotlin / Jetpack Compose
```

## How to Use

**For engineers:** Read the feature spec, reference the tokens, check your platform notes. No Figma — everything you need is in this repo.

1. **`principles.md`** — What Filo values. Read once, internalize.
2. **`tokens.json`** — Every color, font size, spacing, and radius. Do not invent values.
3. **`features/*.md`** — Layout, interactions, states, and per-platform notes for each feature.
4. **`platform-notes/*.md`** — Token mappings, native API guidance, and platform-specific behaviors.

**For AI agents:** Read `SKILL.md` first. It enforces Filo's design system when generating UI code and prevents generic defaults.

## Adding New Specs

1. Create `features/{feature-name}.md`.
2. Include: overview, layout, interactions, states, and a **Platform-Specific Notes** section covering Desktop, iOS, and Android.
3. Reference tokens from `tokens.json` — never hardcode values in specs.

## Source of Truth

| What | Where |
|------|-------|
| Visual tokens | `tokens.json` |
| Design principles | `principles.md` |
| AI design skill | `SKILL.md` |
| **Icons & illustrations** | `resources/icons/`, `resources/illustrations/` |
| Feature behavior | `features/*.md` |
| Platform details | `platform-notes/*.md` |

**Designers:** See `resources/DESIGNER-WORKFLOW.md` for how to add and maintain assets. You own what goes in `resources/`; engineering consumes from here.
