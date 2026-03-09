# Feature Spec: Filo Android Home Screen Widgets

Filo's Android home screen widgets use the **same layout and content** as the iOS and desktop widgets — todo list, Inbox count, and Compose — so the experience is consistent across devices.

**Sizes:** Small, Medium, Large (same content as [ios-widget.md](https://github.com/FiloAI/filo-design/blob/main/features/ios-widget.md))  
**Stack:** Kotlin, [App Widgets](https://developer.android.com/develop/ui/views/appwidgets) or [Glance](https://developer.android.com/develop/ui/compose/glance) (Compose for widgets)

**References:**
- [Android App Widgets](https://developer.android.com/develop/ui/views/appwidgets)
- [Glance for Compose](https://developer.android.com/develop/ui/compose/glance)
- **Design & layout:** [ios-widget.md](https://github.com/FiloAI/filo-design/blob/main/features/ios-widget.md), [desktop-widget-preview.md](https://github.com/FiloAI/filo-design/blob/main/features/desktop-widget-preview.md)
- **Tokens:** [tokens.json](https://github.com/FiloAI/filo-design/blob/main/tokens.json) (Filo Design repo root); map to `res/values/colors.xml` and theme (light/dark)

---

## Shared Data Contract

Same as iOS and desktop. App writes on sync; widget reads from DataStore, Room, or shared file.

```ts
interface WidgetData {
  unreadImportantCount: number;   // e.g. 12
  todos: Array<{
    id: string;
    title: string;
    dueDate?: string;             // ISO date or "Today"
  }>;
}
```

- **Max todos:** Small/Medium = 3, Large = 6.
- **Order:** Sorted by relevance / due date.

---

## Layout (same as iOS / desktop)

Reuse the **same three layouts**; only units and API differ.

| Size   | Content |
|--------|---------|
| **Small**  | Todo list only (up to 3). Tap → open app to **To-do**. |
| **Medium** | Two columns: todo list (left) + vertical action panel (Inbox count + Compose). |
| **Large**  | Todo list (top, up to 6) + bottom action bar (Inbox + Compose, #14 fill). |

- **Title row:** Todo icon (18×18dp, 02-primary) + "To-do" (P2_B) + count (P4_R, 07-text-secondary).
- **Divider:** 0.5dp, 14-overlay-light.
- **Todo rows:** Checkbox (14×14dp, 08-text-tertiary) + title (P4_R, 06-text-primary, 1 line) + optional date (P4_R, 08 or 02 if "Today"). Same as [ios-widget.md](https://github.com/FiloAI/filo-design/blob/main/features/ios-widget.md).
- **Action panel:** Inbox icon + unread count; Compose icon + "Compose" label. Use same tokens (02-primary or #14 panel, white/primary on panel).

---

## Android sizing (dp)

Widget sizes are defined in `res/xml/appwidget_info.xml` with `minWidth` / `minHeight` in dp. Approximate mapping (1 cell ≈ 70dp on a 4×4 grid):

| Layout  | Suggested min size (dp) | Notes |
|---------|--------------------------|--------|
| **Small**  | 110×110 or 250×110       | Todo-only block; square or short strip. |
| **Medium** | 250×110 or 360×110      | Todo list + vertical action panel (same proportions as iOS 364×170). |
| **Large**  | 250×250 or 360×250      | Todo list on top, Inbox+Compose bar at bottom (same as desktop large). |

Use `resizeMode` and optional `targetCellWidth` / `targetCellHeight` so the widget can be resized within the same layout family.

---

## Design tokens

- Map [tokens.json](https://github.com/FiloAI/filo-design/blob/main/tokens.json) to Android color resources and Compose theme.
- Use **adaptive light/dark**: resolve `color.*.light` / `color.*.dark` from tokens by system `isSystemInDarkTheme()`.
- Typography: Roboto (or system default); match P2_B, P4_R, P1.1_B sizes from tokens (sp for text size).

---

## Interactions & deep links

| Tap target | Behavior |
|------------|----------|
| Small widget (entire) | Open app → **To-do** tab |
| Medium/Large: Todo area | Open app → **To-do** tab |
| Medium/Large: Inbox     | Open app → **Inbox** tab |
| Medium/Large: Compose   | Open app → **Compose** screen |

Use an explicit `Intent` with the app's deep-link scheme (e.g. `filo://todo`, `filo://inbox`, `filo://compose`) or Activity intent filters. Minimum touch target: **48×48dp** (Android standard).

---

## Empty state

Same copy as iOS: daily-rotating lines (e.g. "You earned this quiet.", "Clean slate. Nice."). Checkmark circle icon (08-text-tertiary). See [ios-widget.md § Empty State](https://github.com/FiloAI/filo-design/blob/main/features/ios-widget.md#empty-state-all-sizes).

---

## Developer handoff

| Item | Location / note |
|------|------------------|
| Layout & tokens | [ios-widget.md](https://github.com/FiloAI/filo-design/blob/main/features/ios-widget.md), [desktop-widget-preview.md](https://github.com/FiloAI/filo-design/blob/main/features/desktop-widget-preview.md) — same layout, Android dp/sp |
| Widget API | App Widgets (RemoteViews) or Glance (Compose) |
| Data source | App writes `WidgetData`; widget reads via DataStore / Room / file |
| Tokens | [tokens.json](https://github.com/FiloAI/filo-design/blob/main/tokens.json); map to `res/values/colors.xml` and `values-night` |
| Deep links | Register intent filters for `filo://todo`, `filo://inbox`, `filo://compose` |

---

## References

- [Android App Widgets](https://developer.android.com/develop/ui/views/appwidgets)
- [Glance](https://developer.android.com/develop/ui/compose/glance)
- [ios-widget.md](https://github.com/FiloAI/filo-design/blob/main/features/ios-widget.md) — Small / Medium / Large layout and tokens
- [desktop-widget-preview.md](https://github.com/FiloAI/filo-design/blob/main/features/desktop-widget-preview.md) — layout constants and runbook
