# Filo Corner Radius System

Consistent corner radius scale for all Filo apps.

## Radius Scale

| Token | Value | Usage |
|-------|-------|-------|
| **radius-1** | `16px` | Small - buttons, inputs, small cards |
| **radius-2** | `20px` | Medium - cards, modals, containers |
| **radius-3** | `24px` | Large - large cards, sheets |
| **radius-4** | `30px` | Extra large - feature cards, hero elements |
| **radius-pill** | `999px` | Pill shape - single-line cells, tags, chips |

## Visual Reference

```
radius-1 (16px)   ╭────────╮
                  │        │
                  ╰────────╯

radius-2 (20px)   ╭──────────╮
                  │          │
                  ╰──────────╯

radius-3 (24px)   ╭────────────╮
                  │            │
                  ╰────────────╯

radius-4 (30px)   ╭──────────────╮
                  │              │
                  ╰──────────────╯

radius-pill       ╭──────────────────╮
(999px)           ╰──────────────────╯
```

## Key Rule: Single-Line = Pill

**If there's only one line in the cell, shape it as a pill (999).**

```
Single-line cell:    ╭─────────────────────────╮
                     │  Summarize emails       │
                     ╰─────────────────────────╯
                     
Multi-line cell:     ╭─────────────────────────╮
                     │  Email Subject          │
                     │  Preview text here...   │
                     ╰─────────────────────────╯
```

## Common Use Cases

| Component | Radius | Note |
|-----------|--------|------|
| Button (standard) | `16px` | Multi-line or icon buttons |
| Button (pill) | `999px` | Single-line text buttons |
| Input field | `16px` | |
| Card | `20px` | |
| Modal | `24px` | |
| Bottom sheet | `30px` | Top corners only |
| Tag/Chip | `999px` | Always pill |
| Tab bar glass | `999px` | Always pill |
| Suggestion pill | `999px` | Single-line |
| Avatar | `999px` | Circular |
| Badge | `999px` | |

## Usage Examples

### CSS
```css
:root {
  --radius-1: 16px;
  --radius-2: 20px;
  --radius-3: 24px;
  --radius-4: 30px;
  --radius-pill: 999px;
}

.button {
  border-radius: var(--radius-1);  /* 16px */
}

.suggestion-pill {
  border-radius: var(--radius-pill);  /* 999px - single line */
}

.card {
  border-radius: var(--radius-2);  /* 20px */
}

.modal {
  border-radius: var(--radius-3);  /* 24px */
}

.bottom-sheet {
  border-radius: var(--radius-4) var(--radius-4) 0 0;  /* 30px top only */
}
```

### SwiftUI
```swift
// Standard button
.clipShape(RoundedRectangle(cornerRadius: FiloRadius.radius1))

// Pill button (single line)
.clipShape(Capsule())  // or
.clipShape(RoundedRectangle(cornerRadius: FiloRadius.pill))

// Card
.clipShape(RoundedRectangle(cornerRadius: FiloRadius.radius2))
```

## Guidelines

1. **Single-line = Pill** - Always use `999px` for single-line content
2. **Be consistent** - Same radius for same component types
3. **Nested elements** - Inner radius should be smaller than outer
4. **Sheets** - Use `30px` for bottom sheets (top corners only)
