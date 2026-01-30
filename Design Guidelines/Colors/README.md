# Filo Color System

Complete color palette with 25 color tokens supporting light and dark modes.

## Color Tokens

| Token | Name | Light | Dark | Usage |
|-------|------|-------|------|-------|
| 01 | Primary Light | `#1F9EFA` | `#6CC1FF` | Primary accent, lighter variant |
| 02 | Primary | `#22A0FB` | `#45B1FF` | **Primary brand color**, active states, links |
| 03 | Primary Dark | `#4BACF5` | `#213D51` | Primary accent backgrounds |
| 04 | Primary Darker | `#5ABEFF` | `#2E5168` | Darker primary accent |
| 05 | Surface Secondary | `#E8EEF2` | `#344352` | Secondary surface color |
| 06 | Text Primary | `#000000` | `#FFFFFF` | **Primary text color** |
| 07 | Text Secondary | `#707070` | `#8B8B8B` | Secondary text, placeholders |
| 08 | Text Tertiary | `#999999` | `#414149` | Tertiary text, disabled |
| 09 | Surface Tertiary | `#F5F5F5` | `#2A2A30` | Tertiary surface |
| 10 | Background | `#FFFFFF` | `#1D1D21` | **Primary background** |
| 11 | Error | `#E53935` | `#BE424D` | Error states, destructive actions |
| 12 | Warning | `#FFB800` | `#FFDC84` | Warning states, caution |
| 13 | Info | `#22A0FB` | `#3DAEFF` | Information, links |
| 14 | Overlay Light | `rgba(0,0,0,0.04)` | `rgba(255,255,255,0.06)` | Light overlays, selections |
| 15 | Overlay Primary | `rgba(34,160,251,0.08)` | `rgba(76,180,255,0.12)` | Primary color overlays |
| 16 | Overlay Subtle | `rgba(0,0,0,0.02)` | `rgba(75,91,103,0.08)` | Subtle overlays |
| 17 | Success Light | `#E8F5CE` | `#9BB26C` | Success backgrounds |
| 18 | Success | `#7EBA02` | `#7EBA02` | Success states |
| 19 | Warning Alt | `#F7A501` | `#F7A501` | Alternative warning |
| 20 | Error Light | `#FFE5E7` | `#461D21` | Error backgrounds |
| 21 | Purple Light | `#E8E6F5` | `#B4AEDC` | Purple accent light |
| 22 | Purple | `#7F6EFF` | `#7F6EFF` | Purple accent |
| 23 | Pink Light | `#FFF0F5` | `#F6D4FF` | Pink accent light |
| 24 | Pink | `#BF3EE2` | `#BF3EE2` | Pink accent |
| 25 | Neutral | `#9E9E9E` | `#727272` | Neutral gray |

## Key Colors

### Brand Colors
- **Primary (#02):** `#22A0FB` (light) / `#45B1FF` (dark) - The Filo blue

### Text Colors
- **Primary (#06):** `#000000` (light) / `#FFFFFF` (dark)
- **Secondary (#07):** `#707070` (light) / `#8B8B8B` (dark)
- **Tertiary (#08):** `#999999` (light) / `#414149` (dark)

### Background Colors
- **Background (#10):** `#FFFFFF` (light) / `#1D1D21` (dark)
- **Surface (#09):** `#F5F5F5` (light) / `#2A2A30` (dark)

### Semantic Colors
- **Error (#11):** `#E53935` (light) / `#BE424D` (dark)
- **Warning (#12):** `#FFB800` (light) / `#FFDC84` (dark)
- **Success (#18):** `#7EBA02` (both modes)

## Glass Effect (iOS 26)

For the liquid glass effect on iOS 26:

### Light Mode
```css
background: rgba(247, 247, 247, 0.85);
border: rgba(255, 255, 255, 0.5);
backdrop-filter: blur(20px);
```

### Dark Mode
```css
background: rgba(40, 40, 40, 0.85);
border: rgba(255, 255, 255, 0.1);
backdrop-filter: blur(20px);
```

## Usage Examples

### CSS Variables
```css
:root {
  --filo-01: #1F9EFA;
  --filo-02: #22A0FB;
  --filo-06: #000000;
  --filo-07: #707070;
  --filo-10: #FFFFFF;
  --filo-14: rgba(0, 0, 0, 0.04);
}

@media (prefers-color-scheme: dark) {
  :root {
    --filo-01: #6CC1FF;
    --filo-02: #45B1FF;
    --filo-06: #FFFFFF;
    --filo-07: #8B8B8B;
    --filo-10: #1D1D21;
    --filo-14: rgba(255, 255, 255, 0.06);
  }
}
```

### SwiftUI
```swift
extension Color {
    static let filo02 = Color("Filo02") // Define in Asset Catalog
    static let filo06 = Color("Filo06")
    static let filo10 = Color("Filo10")
}
```

## Figma Source

- **File:** Components (`Pmns0wqmroGCQmqFPeSrwd`)
- **Light Palette:** Node `1-1187`
- **Dark Palette:** Node `1-1263`
