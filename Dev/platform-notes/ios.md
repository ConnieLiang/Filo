# Platform Notes: iOS

**Repo:** `FiloAI/filo-ios`
**Stack:** Swift / SwiftUI (iOS 17+)

---

## Architecture

iOS is a native SwiftUI app. There is no Figma in this workflow — engineers implement from the specs and tokens in `Dev/`.

### Key Directories

| Path | Purpose |
|------|---------|
| `FiloApp/Assets.xcassets` | Icons and image resources (provide .png at 1x/2x/3x) |
| `FiloApp/bean/` | Data structures |
| `FiloApp/model/` | Data models |
| `CLAUDE.md` | Project overview and architecture notes |

---

## Design-to-Engineering Handoff

The handoff is spec-driven, not file-driven. No Figma links or design files are involved.

1. Read the feature spec in `Dev/features/` — each spec has an iOS-specific section with gestures, navigation, and component decisions.
2. Reference `Dev/tokens.json` for all color, spacing, typography, and radius values.
3. Use SVG icons from `Resources/Icons/Library/`. Export to `.png` at 1x/2x/3x and place in `FiloApp/Assets.xcassets/`.

---

## iOS-Specific Interaction Patterns

### Gestures

| Gesture | Behavior |
|---------|----------|
| Swipe left (short) | Archive |
| Swipe left (long) | Delete |
| Swipe right (short) | Mark read/unread |
| Long-press | Context menu (Reply, Forward, Archive, Delete, Label, Snooze) |
| Pull-to-refresh | Refresh inbox |

Implement swipe actions via SwiftUI `.swipeActions` modifier. Context menus via `.contextMenu`.

### System Components vs Custom

| Component | Use Native? | Notes |
|-----------|-------------|-------|
| Navigation | Yes | `NavigationStack` with push transitions |
| Sheets | Yes | `.sheet` / `.fullScreenCover` |
| Alerts | Yes | `.alert` for confirmations |
| Context menus | Yes | `.contextMenu` |
| Tab bar | Custom | Filo tab bar with pill radius, not system `TabView` |
| Cards | Custom | Filo card component with design tokens |

### Navigation Model

- Primary: `NavigationStack` with push (email list → detail).
- Compose: Modal (`.fullScreenCover` on iPhone, `.sheet` on iPad).
- Settings/sub-pages: Push navigation within a `NavigationStack`.
- Avoid excessive modal stacking.

---

## Navigation Bars (iOS 26 Liquid Glass)

Filo uses Apple's native Liquid Glass on iOS 26+. Do not recreate the glass effect manually — use SwiftUI's built-in `.glassEffect()` modifier and system navigation bar styling.

| Variant | Left | Center | Right |
|---------|------|--------|-------|
| Read Email | Back button | — | Reply, More |
| Select Email | Cancel | Count label | Archive, Delete, More |
| Compose | Cancel | — | Send |
| Subpage | Back button | Title | Action (varies) |

- Use `NavigationStack` with standard `.toolbar` — iOS 26 applies Liquid Glass automatically.
- For custom glass surfaces, apply `.glassEffect()` on the container view.
- Min touch target: 44pt
- Icon button size: 42×42pt, icon 20px
- Brand primary for active items: `#22A0FB`

```swift
.toolbar {
    ToolbarItem(placement: .topBarLeading) {
        Button(action: goBack) {
            Image(systemName: "chevron.left")
        }
    }
    ToolbarItem(placement: .topBarTrailing) {
        Button(action: reply) {
            Image("reply")
        }
        .tint(Color.filoPrimary)
    }
}
```

---

## Typography Mapping

| Token | SwiftUI |
|-------|---------|
| H1 (40pt Bold) | `.font(.system(size: 40, weight: .bold))` |
| P2_R (16pt Regular) | `.font(.system(size: 16, weight: .regular))` |
| P4_R (13pt Regular) | `.font(.system(size: 13, weight: .regular))` |

Use `@ScaledMetric` or Dynamic Type support where appropriate for accessibility.

---

## Color Mapping

Define colors in `Assets.xcassets` with light/dark variants, or use SwiftUI `Color` with conditional values:

```swift
extension Color {
    static let filoPrimary = Color("filoPrimary")  // #22A0FB / #45B1FF
    static let filoBackground = Color("filoBackground")  // #FFFFFF / #1D1D21
    static let filoTextSecondary = Color("filoTextSecondary")  // #707070 / #8B8B8B
}
```

All 25 color tokens must have both light and dark variants in the asset catalog.

---

## Dark Mode

- Fully supported. All tokens have light/dark values.
- Use `@Environment(\.colorScheme)` only when conditionally adjusting beyond token colors.
- Test all screens in both modes.

---

## Accessibility

- Support Dynamic Type (font scaling).
- All interactive elements must have accessibility labels.
- VoiceOver: email list rows should announce sender, subject, time, and label.
- Minimum touch target: 44×44pt.

---

## Asset Submission

To add icons or images:

1. Source SVGs live in `Resources/Icons/Library/`. Export to `.png` at 1x, 2x, and 3x using any export tool (e.g., svgexport, Inkscape, or a batch script).
2. Place in `FiloApp/Assets.xcassets/` under the appropriate `.imageset` folder.
3. Update the `Contents.json` inside the imageset if adding new assets.
4. Submit a PR to `filo-ios`.
