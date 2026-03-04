# Dev

Design guidelines for engineers building Filo. This is the shared reference for all three platforms.

## Structure

```
Dev/
├── tokens.json              # Colors, typography, spacing, radius, dividers (all platforms)
├── principles.md            # Product design principles and visual direction
├── filo-designer-toolkit.md # Designer onboarding guide
├── features/                # Feature interaction specs
│   ├── email-list.md        # Email list — layout, states, interactions, per-platform notes
│   └── compose.md           # Compose — fields, Instant Write, per-platform notes
└── platform-notes/          # Platform-specific engineering guidance
    ├── desktop.md           # Electron + React + Radix UI
    ├── ios.md               # Swift / SwiftUI
    └── android.md           # Kotlin / Jetpack Compose
```

## How to Use

1. **Start with `principles.md`** — Understand what Filo values before building anything.
2. **Reference `tokens.json`** — Every color, font size, spacing, and radius value lives here. Do not invent values.
3. **Read the feature spec** — Before implementing a feature, read its spec in `features/`. Each spec includes layout, interactions, and per-platform notes.
4. **Check your platform notes** — `platform-notes/` has architecture details, token mappings, and platform-specific behaviors for your stack.

## Adding New Specs

When a new feature is ready for engineering:

1. Create `features/{feature-name}.md`.
2. Include: overview, layout, interactions, states, and a **Platform-Specific Notes** section covering Desktop, iOS, and Android.
3. Reference tokens from `tokens.json` — never hardcode values in specs.

## Source of Truth

| What | Where |
|------|-------|
| Visual tokens | `Dev/tokens.json` |
| Design principles | `Dev/principles.md` |
| Feature behavior | `Dev/features/*.md` |
| Platform details | `Dev/platform-notes/*.md` |
| Full design system | `Design Guidelines/` (detailed JSON files with Figma references) |
| Product vision | `About Filo.md` |
