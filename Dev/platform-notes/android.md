# Platform Notes: Android

**Repo:** `FiloAI/filo-android`
**Stack:** Kotlin / Jetpack Compose (and some Android Views)

---

## Architecture

Android is a native Kotlin app. There is no Figma in this workflow — engineers implement from the specs and tokens in `Dev/`, and can also receive resource file PRs (colors, icons) directly.

### Directories Designers Can Contribute To

| Path | What Goes Here |
|------|----------------|
| `app/src/main/res/drawable/` | Icon SVG/PNG resources |
| `app/src/main/res/drawable-night/` | Dark-mode-specific icon variants |
| `app/src/main/res/color/` | Color definitions (XML format) |
| `app/src/main/res/values/colors.xml` | Named color values |

---

## Design-to-Engineering Handoff

The handoff is spec-driven, not file-driven. No Figma links or design files are involved.

1. Read the feature spec in `Dev/features/` — each spec has an Android-specific section with back-button behavior, gestures, and notification patterns.
2. Reference `Dev/tokens.json` for all color, spacing, typography, and radius values.
3. Use SVG icons from `Resources/Icons/Library/`. Convert to vector drawables or PNGs for `res/drawable/`.

Resource files (colors, icons) can also be contributed directly via PR:

### Color Resources

Map Filo tokens to Android XML. Example for `res/values/colors.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="filo_primary">#22A0FB</color>
    <color name="filo_background">#FFFFFF</color>
    <color name="filo_text_primary">#000000</color>
    <color name="filo_text_secondary">#707070</color>
    <color name="filo_text_tertiary">#999999</color>
    <color name="filo_error">#E53935</color>
    <color name="filo_warning">#FFB800</color>
    <color name="filo_success">#7EBA02</color>
    <color name="filo_surface">#F5F5F5</color>
</resources>
```

Dark mode variants go in `res/values-night/colors.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="filo_primary">#45B1FF</color>
    <color name="filo_background">#1D1D21</color>
    <color name="filo_text_primary">#FFFFFF</color>
    <color name="filo_text_secondary">#8B8B8B</color>
    <color name="filo_text_tertiary">#414149</color>
    <color name="filo_error">#BE424D</color>
    <color name="filo_warning">#FFDC84</color>
    <color name="filo_success">#7EBA02</color>
    <color name="filo_surface">#2A2A30</color>
</resources>
```

### Color Selector Files

For stateful colors (e.g., a color that changes on press), use `res/color/`:

```xml
<!-- res/color/filo_primary_selector.xml -->
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:state_pressed="true" android:color="#1F9EFA"/>
    <item android:color="#22A0FB"/>
</selector>
```

### Icon Resources

- Place SVG or PNG files in `res/drawable/`.
- For dark-mode-specific icons, add variants in `res/drawable-night/`.
- Naming convention: `ic_filo_{icon_name}.xml` (for vector drawables) or `.png`.

---

## Android-Specific Interaction Patterns

### System Back Button / Gesture

| Context | Back Behavior |
|---------|---------------|
| Email detail | Return to email list |
| Compose (empty) | Dismiss immediately |
| Compose (with content) | Prompt: "Discard draft?" with Save Draft / Discard |
| Settings sub-page | Return to parent settings screen |
| Search | Close search, return to previous screen |

This must be explicitly handled. Use `OnBackPressedDispatcher` or Compose `BackHandler`.

### Notifications

| Type | Style | Actions |
|------|-------|---------|
| New email | BigTextStyle with sender + subject preview | Mark Read, Archive |
| Action required | Standard with label color accent | Open, Dismiss |

Request notification permission at first launch with honest copy:
> "Filo can notify you when something needs your attention. You can change this anytime in Settings."

### Gestures

| Gesture | Behavior |
|---------|----------|
| Swipe left (short) | Archive |
| Swipe left (long) | Delete |
| Swipe right (short) | Mark read/unread |
| Long-press | Context menu |

Implement via `SwipeToDismiss` (Jetpack Compose) or `ItemTouchHelper` (RecyclerView).

---

## Material Design Compliance

Filo uses its own design system, not stock Material Design. However:

- Use Material 3 components as a base when they align (e.g., `TopAppBar`, `Scaffold`).
- Override Material theming with Filo tokens (colors, typography, shapes).
- Do NOT rely on Material You dynamic color — Filo has its own palette.
- Follow Material guidance for accessibility (touch targets, contrast ratios).

---

## Typography Mapping

| Filo Token | Compose Equivalent |
|------------|-------------------|
| H1 (40sp Bold) | `TextStyle(fontSize = 40.sp, fontWeight = FontWeight.Bold)` |
| P2_R (16sp Regular) | `TextStyle(fontSize = 16.sp, fontWeight = FontWeight.Normal)` |
| P4_R (13sp Regular) | `TextStyle(fontSize = 13.sp, fontWeight = FontWeight.Normal)` |

Use `sp` units (not `dp`) for text to respect user font-size preferences.

---

## Dark Mode

- Fully supported via `values-night/` resource qualifiers.
- In Compose: use `isSystemInDarkTheme()` to select token variants.
- All 25 Filo color tokens must have both light and dark values defined.
- Test all screens in both modes.

---

## Accessibility

- Minimum touch target: 48×48dp (Android standard).
- Content descriptions on all icons and interactive elements.
- TalkBack: email list rows should announce sender, subject, time, label.
- Support font scaling via `sp` units.

---

## Share Intent

Filo should register as a share target so users can compose emails with attachments from other apps:

```xml
<intent-filter>
    <action android:name="android.intent.action.SEND"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <data android:mimeType="*/*"/>
</intent-filter>
```

---

## Permissions

Request permissions at the moment of need, not at launch (except notification permission). Always explain why:

| Permission | When | Copy |
|------------|------|------|
| Notifications | First launch | "Filo can notify you when something needs your attention." |
| Camera | Composing with camera attachment | "Filo needs camera access to attach photos." |
| Storage | Attaching files | "Filo needs access to attach files from your device." |
