# Filo Dividers

Divider rules for separating content in both mobile and desktop versions of Filo.

## Types

### Standard Divider
- **Color:** `--filo-08` (#08)
- **Height:** 0.5px
- **Width:** Full width (100%)
- **Usage:** General content separation between list items, sections, or content blocks

```css
border-bottom: 0.5px solid var(--filo-08);
```

### Subtle Divider
- **Color:** `--filo-14` (#14)
- **Height:** 0.5px
- **Width:** Full width (100%)
- **Usage:** Frame edge differentiation when one frame overlaps another, creating subtle depth separation

```css
border-bottom: 0.5px solid var(--filo-14);
```

## When to Use

| Divider | Use Case |
|---------|----------|
| Standard (#08) | List separators, section dividers, general content breaks |
| Subtle (#14) | Overlapping frame edges, layered UI elements, subtle visual hierarchy |
