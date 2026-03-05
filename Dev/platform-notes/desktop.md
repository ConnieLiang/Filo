# Platform Notes: Desktop

**Repo:** `FiloAI/filo-desktop`
**Stack:** Electron + React + Radix UI + Tailwind CSS

---

## Architecture

Desktop is the primary development platform. The `Dev/` design directory lives here so all platform engineers can access it.

### Key Directories

| Path | Purpose |
|------|---------|
| `src/components/` | React UI components |
| `src/pages/` | Top-level page layouts |
| `src/styles/` | Global styles, Tailwind config |
| `Dev/` | Design tokens, principles, feature specs, platform notes |

---

## Design-to-Code Workflow

There is no Figma in this workflow. Design specs, tokens, and icon assets are the source of truth.

1. Read the feature spec in `Dev/features/` for layout, interactions, and states.
2. Reference `Dev/tokens.json` for every color, spacing, radius, and typography value.
3. Use SVG icons from `Resources/Icons/Library/`.
4. Build components using React + Radix UI + Tailwind, mapped to Filo tokens.
5. For prototyping, tools like MagicPatterns or v0.dev can generate starter code — feed them the tokens and spec context.
6. Submit a PR to `src/components/`.

---

## Component Library

- **UI primitives:** Radix UI (Dialog, ContextMenu, DropdownMenu, Tooltip, etc.)
- **Styling:** Tailwind CSS, mapped to Filo design tokens
- **Icons:** SVG imports from `Resources/Icons/Library/`

### Token Mapping (Tailwind)

Map Filo tokens to Tailwind `theme.extend` in `tailwind.config.js`:

```js
colors: {
  'filo-primary':      'var(--filo-02)',
  'filo-bg':           'var(--filo-10)',
  'filo-surface':      'var(--filo-09)',
  'filo-text':         'var(--filo-06)',
  'filo-text-secondary': 'var(--filo-07)',
  'filo-error':        'var(--filo-11)',
  'filo-success':      'var(--filo-18)',
}
```

---

## Desktop-Specific Behaviors

### Layout

- Three-pane: sidebar (folders/labels) → email list → email detail/compose
- Resizable panes
- Sidebar collapsible

### Navigation

- Keyboard-driven: arrow keys, Enter, Delete/Backspace, Cmd+N (compose), Cmd+F (search)
- Tab key for focus management between panes
- Cmd+Enter to send from compose

### Hover States

- Email list rows: background changes to overlay-subtle (#16) on hover
- Buttons: opacity 0.9 on hover
- Interactive elements must have visible focus rings for accessibility

### Context Menus

- Right-click on email row → Radix `ContextMenu` with: Reply, Forward, Archive, Delete, Mark read/unread, Label, Snooze
- Right-click on sidebar items → Rename, Delete, Move

### Window Management

- Compose can open inline (right pane) or as a floating window
- Support multiple floating compose windows
- Window title: "Filo — [subject or 'New Email']"

---

## Design QA Process

QA is done against the running build and the specs in `Dev/` — not against a Figma file.

1. Pull the latest Desktop build.
2. Run through the main user flows (inbox, read, compose, search).
3. Compare against the feature spec in `Dev/features/` and the token values in `Dev/tokens.json`.
4. For visual or interaction issues, open a GitHub Issue with label `design-qa`.
5. Include: screenshot, expected behavior, actual behavior, and the relevant token/component reference from `Dev/`.

---

## Dark Mode

Desktop respects the OS dark mode setting. All color tokens have light/dark variants — reference `tokens.json` and use CSS custom properties that switch based on `prefers-color-scheme`.

---

## Glass Effect (Optional)

For macOS-style translucent panels:

```css
.glass {
  background: rgba(247, 247, 247, 0.85);  /* light */
  border: 1px solid rgba(255, 255, 255, 0.5);
  backdrop-filter: blur(20px);
}
```

Use sparingly. Clarity over decoration.
