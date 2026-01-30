# Screen Specifications

This folder contains design specifications for Filo's screens, extracted from Figma.

## Files

| File | Description | Platform |
|------|-------------|----------|
| `sign-in-screen.json` | Sign-in/launch screen | iOS |

## Usage

Each JSON file contains:

- **figma** — Source file reference (fileKey, nodeId, URL)
- **frame** — Screen dimensions and target platform
- **background** — Background color or gradient
- **elements** — All UI elements with positioning, sizing, and styling
- **statusBar** — Status bar configuration

## Implementation

SwiftUI implementations are in `iOS/Views/` and `macOS/Views/`.

| Screen | iOS Implementation |
|--------|-------------------|
| Sign In | `iOS/Views/SignInView.swift` |

## Adding New Screens

1. Export CSS from Figma (right-click → Copy as CSS)
2. Create a new JSON file following the existing structure
3. Create the corresponding SwiftUI view
4. Update this README
