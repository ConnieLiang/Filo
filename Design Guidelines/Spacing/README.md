# Filo Spacing System

Consistent spacing scale used across all Filo apps.

## Spacing Scale

| Token | Value | Usage |
|-------|-------|-------|
| **space-1** | `4px` | Micro spacing - icon padding, tight gaps |
| **space-2** | `8px` | Small spacing - between related elements, button padding |
| **space-3** | `12px` | Medium-small - list item gaps, card padding |
| **space-4** | `16px` | Medium - section padding, standard gaps |
| **space-5** | `20px` | Medium-large - container padding, between sections |
| **space-6** | `30px` | Large - major section gaps |
| **space-7** | `40px` | Extra large - page margins, hero sections |

## Visual Reference

```
4px   ████
8px   ████████
12px  ████████████
16px  ████████████████
20px  ████████████████████
30px  ██████████████████████████████
40px  ████████████████████████████████████████
```

## Common Use Cases

| Component | Spacing |
|-----------|---------|
| Icon padding | `4px` |
| Button padding (vertical) | `8px` |
| Button padding (horizontal) | `16px` |
| List item gap | `12px` |
| Card padding | `16px` |
| Section gap | `20px` |
| Page margin | `20px` |
| Modal padding | `20px` |
| Header padding | `16px` |
| Input padding | `12px` |

## Usage Examples

### CSS
```css
:root {
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-5: 20px;
  --space-6: 30px;
  --space-7: 40px;
}

.card {
  padding: var(--space-4);  /* 16px */
  gap: var(--space-3);      /* 12px */
}

.section {
  margin-bottom: var(--space-5);  /* 20px */
}
```

### SwiftUI
```swift
struct FiloSpacing {
    static let space1: CGFloat = 4
    static let space2: CGFloat = 8
    static let space3: CGFloat = 12
    static let space4: CGFloat = 16
    static let space5: CGFloat = 20
    static let space6: CGFloat = 30
    static let space7: CGFloat = 40
}

// Usage
VStack(spacing: FiloSpacing.space3) {
    // content
}
.padding(FiloSpacing.space4)
```

## Guidelines

1. **Use the scale** - Always pick from the 7 spacing values
2. **Be consistent** - Same spacing for same contexts
3. **Start small** - Use smaller values for tight relationships
4. **Scale up** - Use larger values to create visual hierarchy
