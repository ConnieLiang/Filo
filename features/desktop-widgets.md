# Feature Spec: Filo Desktop Widgets

Filo's desktop widgets let people check what matters and start writing without opening the app — so email stays useful without demanding attention. **macOS is Filo's primary platform;** the widget experience there must be magnificent. Windows users get the same value via the Widgets Board.

**Platforms:** macOS (native WidgetKit), Windows (Widget Provider)  
**Data & design:** Shared contract and Filo tokens; reuse [iOS widget spec](ios-widget.md) for layout, copy, and tokens.

---

## Shared Data Contract

All widgets (iOS, macOS, Windows) use the same contract so backends and sync stay consistent.

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

- **Max todos:** Small/Medium = 3, Large = 6 (same as iOS).
- **Order:** Sorted by relevance / due date.
- **Source:** Main app (Electron on desktop) writes on sync; widgets read via platform-specific mechanism (App Group / shared file / local API).

---

## Design: Reuse iOS Widget Spec

- **Tokens:** Use the same Filo design tokens as the iOS widget. See [ios-widget.md § Design Tokens](ios-widget.md#design-tokens) and `tokens.json`.
- **Copy:** Same empty-state and label copy (e.g. "To-do", "Compose", daily-rotating empty lines).
- **Layout and typography:** Same element specs (P2_B for "To-do", P4_R for todo title/date, P1.1_B for unread count, etc.) so the experience is consistent across devices.
- **Icons:** Same Filo icon set (todo, inbox-before, compose); template rendering with 02-primary or white on blue panel.

---

## macOS: Native Widgets (WidgetKit)

macOS is the primary platform; widgets must feel native and polished. Use **WidgetKit + SwiftUI** so widgets appear on the desktop and in Notification Center (macOS Sonoma+).

### Implementation model

- **Filo Desktop** is Electron. Native macOS widgets require a **host** that ships a WidgetKit extension.
- **Option A (recommended):** A small **companion app** (Swift/SwiftUI) that only exists to host the widget extension. No main UI; it appears in the dock only if the user opens it (or hide it). Electron app writes `WidgetData` to a **shared location** (e.g. `~/Library/Application Support/Filo/widget-data.json` or App Group if the companion is signed with the same team). Widget reads via `TimelineProvider`.
- **Option B:** If Filo ever ships a native macOS app (Swift/SwiftUI), the widget extension lives there and shares data via App Group.

### Widget families (parity with iOS)

| Family | Content (same as iOS) |
|--------|------------------------|
| **Small** | Todo list only (up to 3). Tap → open app to To-do. |
| **Medium** | Two columns: todo list (left) + vertical action panel (Inbox count + Compose). |
| **Large** | Two rows: horizontal action panel (Inbox + Compose) top, todo list (up to 6) below. |

- **Optional:** macOS supports `.systemExtraLarge`; can be added later for a larger glance view.
- **Layout, typography, colors:** Implement exactly as in [ios-widget.md](ios-widget.md) (Small / Medium / Large sections). Same tokens, same components (FiloTodoTitle, FiloTodoRow, FiloTodoList, FiloEmptyState, FiloActionPanel).
- **Deep links:** Use a custom URL scheme that opens **Filo Desktop** (Electron) and focuses the right tab (e.g. `filo://inbox`, `filo://compose`, `filo://todo`). Electron must register the URL scheme and handle these.

### macOS-specific notes

- **Container:** Use `.contentMarginsDisabled()` for edge-to-edge action panel where applicable.
- **Light/dark:** Adaptive colors from tokens (same as iOS).
- **Accessibility:** VoiceOver labels on all interactive elements; checkbox intent: "Complete: [task name]".
- **Minimum:** macOS 14+ (Sonoma) for desktop widgets.

### Developer handoff (macOS)

| Item | Location / note |
|------|------------------|
| Layout & tokens | [ios-widget.md](ios-widget.md) — reuse Small / Medium / Large |
| Widget host | New companion app or existing native macOS app |
| Data source | Shared file or App Group; Electron writes, widget reads |
| Display name | "Filo" |
| Description | "Emails and tasks at a glance." |

---

## Windows: Widget Provider

Windows users get Filo in the **Widgets Board** (Win + W) via a **Widget Provider** using the Windows App SDK. The provider is a native component; the Electron app supplies data (e.g. local HTTP or shared JSON).

### Implementation model

- **Widget Provider:** Implement with **Windows App SDK** (C# or C++/WinRT). The provider registers widgets and returns content in **Adaptive Cards** (JSON) or via the Widget SDK APIs.
- **Data:** Electron (Filo Desktop) writes `WidgetData` to a known location or exposes a small local HTTP endpoint. The provider (or a small broker process) reads this and passes data to the widget runtime.
- **UI:** Adaptive Cards have limited layout compared to SwiftUI. Map the widget content to cards:
  - **Compact:** Unread count + "Compose" action; optional 1-line todo.
  - **Wider:** Unread count, 2–3 todos (title + optional date), "Inbox" and "Compose" actions.
- **Design:** Use Filo tokens as closely as Adaptive Cards allow (colors, font sizes). Reuse the same **copy** ("To-do", "Compose", empty-state lines). If the card format doesn't support custom fonts, use system fonts and match sizes (e.g. 13pt for todo title, 17pt bold for count).

### Actions / deep links

- **Open Inbox / To-do / Compose:** Use protocol activation (e.g. `filo://inbox`) or launch the Electron app with arguments so it opens the correct view. Electron must register the protocol and handle it.

### Developer handoff (Windows)

| Item | Note |
|------|------|
| API | [Widget providers - Windows apps](https://learn.microsoft.com/en-us/windows/apps/develop/widgets/widget-providers) |
| Samples | [Windows Widgets Samples](https://learn.microsoft.com/en-us/samples/microsoft/windowsappsdk-samples/widgets/) |
| Data | Same `WidgetData` contract; Electron provides via file or local API |
| Design | Map [ios-widget.md](ios-widget.md) tokens and copy to Adaptive Cards / widget template |

---

## Summary

| Platform | Mechanism | Data source | Design |
|----------|------------|-------------|--------|
| **macOS** | Native WidgetKit (Swift/SwiftUI) in companion or native app | Shared file or App Group; Electron writes | Same as iOS widget spec (tokens, layout, copy) |
| **Windows** | Widget Provider (Windows App SDK) | Electron writes; provider reads (file or local API) | Same data & copy; tokens mapped to Adaptive Cards |

- **Data:** `{ unreadImportantCount, todos: [{ id, title, dueDate? }] }` everywhere.
- **Design:** Reuse Filo tokens and copy from the [iOS widget spec](ios-widget.md) so tray, menu, and widgets feel consistent across iOS, macOS, and Windows.
