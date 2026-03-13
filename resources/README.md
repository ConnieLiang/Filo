# Resources

Design and product assets that live in **filo-design** as the single source of truth. Engineering consumes these (via submodule, copy, or build step) for all Filo apps.

## Structure

```
resources/
├── README.md             ← You are here
├── DESIGNER-WORKFLOW.md  ← How to add and maintain assets
├── icons/                ← Product icons (SVG)
│   ├── icons.json        ← Catalog and categories
│   ├── README.md
│   └── *.svg
├── illustrations/        ← Spot illustrations, empty/error states, onboarding
│   └── README.md
└── logos/                 ← Brand logos (SVG)
    ├── Default-Horizontal.svg
    ├── Default-Vertical.svg
    ├── Mono-Horizontal.svg
    └── Mono-Vertical.svg
```

## What goes here

| Type | Folder | Format | Use |
|------|--------|--------|-----|
| **Icons** | `icons/` | SVG | UI icons (nav, actions, email, settings, etc.) |
| **Illustrations** | `illustrations/` | SVG, PNG (2x+) | Empty/error states, onboarding, marketing |
| **Logos** | `logos/` | SVG | Brand mark: default and mono, horizontal and vertical |
| *(Future)* | — | — | Lottie, sounds, or other asset types as needed |

## Why this lives in filo-design

- **One source of truth** — Design owns the assets; no scattered copies.
- **Your value as designer** — You add, name, and categorize; engineering consumes. Clear handoff.
- **Versioned with design** — Changes to tokens, components, and assets ship together in one repo.
- **Easier review** — PRs in filo-design show exactly what changed (icons, illustrations, docs).

## Workflow

1. **Add or update assets** in the right folder (`icons/`, `illustrations/`, …).
2. **Update catalog/docs** (e.g. `icons.json`, folder README) so names and usage are clear.
3. **Commit and push** in filo-design; open PR if your workflow uses it.
4. **Apps** pull from filo-design (submodule or sync) and use the new paths.

See **DESIGNER-WORKFLOW.md** for step-by-step and conventions.

## Current illustration packs

- `illustrations/Empty & Error/`
  - 9 PNG assets (`01.png` … `09.png`)
  - Used for app empty/error state visuals across platforms
