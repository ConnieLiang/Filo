# Filo Typography System

Complete typography scale using SF Pro (sans-serif) and New York Small (serif) fonts.

## Font Families

| Font | Type | Usage |
|------|------|-------|
| **SF Pro** | Sans-serif | Primary UI font |
| **New York Small** | Serif | Email content, reading |

## Type Scale

### Headers (SF Pro Bold)

| Style | Size | Line Height | Kerning | Usage |
|-------|------|-------------|---------|-------|
| **H1** | 40px | 52px | 0.2 | Main page titles, hero sections |
| **H2** | 32px | 42px | 0.2 | Section headers |
| **H3** | 28px | 36px | 0.1 | Sub-section headers |
| **H4** | 26px | 32px | 0 | Card titles, modal headers |
| **H5** | 22px | 24px | 0 | Small headers, labels |

### Paragraph - Large (P1)

| Style | Font | Weight | Size | Line Height | Kerning |
|-------|------|--------|------|-------------|---------|
| **P1_B** | SF Pro | Bold | 19px | 26px | -0.2 |
| **P1_M** | SF Pro | Medium | 19px | 26px | -0.2 |

### Paragraph - Body (P1.1)

| Style | Font | Weight | Size | Line Height | Kerning |
|-------|------|--------|------|-------------|---------|
| **P1.1_B** | SF Pro | Bold | 17px | 24px | -0.2 |
| **P1.1_R** | SF Pro | Regular | 17px | 24px | -0.2 |
| **P1.1_R_Italic** | SF Pro | Regular Italic | 17px | 24px | -0.2 |

### Paragraph - Serif (P1S)

| Style | Font | Weight | Size | Line Height | Kerning |
|-------|------|--------|------|-------------|---------|
| **P1S_B** | New York Small | Bold | 18px | 27px | 0 |
| **P1S_M** | New York Small | Medium | 18px | 27px | 0 |

### Paragraph - Standard (P2)

| Style | Font | Weight | Size | Line Height | Kerning |
|-------|------|--------|------|-------------|---------|
| **P2_B** | SF Pro | Bold | 16px | 20px | -0.2 |
| **P2_M** | SF Pro | Medium | 16px | 20px | -0.2 |
| **P2_R** | SF Pro | Regular | 16px | 20px | -0.2 |
| **P2S_B** | New York Small | Bold | 16px | 20px | 0 |
| **P2S_R** | New York Small | Regular | 16px | 20px | 0 |

### Paragraph - Small (P3)

| Style | Font | Weight | Size | Line Height | Kerning |
|-------|------|--------|------|-------------|---------|
| **P3_B** | SF Pro | Bold | 15px | 20px | -0.2 |
| **P3_M** | SF Pro | Medium | 15px | 20px | -0.2 |
| **P3_R** | SF Pro | Regular | 15px | 20px | -0.2 |
| **P3.1_M** | SF Pro | Medium | 14px | 18px | -0.2 |

### Caption & Micro (P4, P5)

| Style | Font | Weight | Size | Line Height | Kerning |
|-------|------|--------|------|-------------|---------|
| **P4_B** | SF Pro | Bold | 13px | 15px | 0 |
| **P4_R** | SF Pro | Regular | 13px | 15px | 0 |
| **P5_B** | SF Pro | Bold | 10px | 12px | 0 |
| **P5_R** | SF Pro | Regular | 10px | 12px | 0 |

## Usage Examples

### CSS

```css
.h1 {
    font-family: -apple-system, BlinkMacSystemFont, 'SF Pro', system-ui, sans-serif;
    font-weight: 700;
    font-size: 40px;
    line-height: 52px;
    letter-spacing: 0.2px;
}

.p2-r {
    font-family: -apple-system, BlinkMacSystemFont, 'SF Pro', system-ui, sans-serif;
    font-weight: 400;
    font-size: 16px;
    line-height: 20px;
    letter-spacing: -0.2px;
}

.p1s-m {
    font-family: 'New York Small', Georgia, serif;
    font-weight: 500;
    font-size: 18px;
    line-height: 27px;
    letter-spacing: 0;
}
```

### SwiftUI

```swift
Text("Hello")
    .font(.filoH1)

Text("Body text")
    .font(.filoP2R)
```

## Figma Source

- **File:** Components (`Pmns0wqmroGCQmqFPeSrwd`)
- **Node:** `1-1339`
