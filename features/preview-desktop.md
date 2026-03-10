# Preview Filo Desktop

Filo Desktop is an **Electron** app (React + Radix UI + Tailwind). It does **not** use Xcode — you run and preview it from the terminal.

## Repo location

Cloned from https://github.com/FiloAI/filo-desktop.git:

```
<your-workspace>/
└── filo-desktop/     ← Electron app
```

## How to preview on your Mac

**One-time setup** (if you haven’t already):

```bash
cd <path-to>/filo-desktop
pnpm install
git submodule update --init --recursive
```

**Run the app** (leave Terminal open):

```bash
cd filo-desktop && pnpm electron:dev
```

The Filo Desktop window will open in 20–30 seconds. If you have **FiloPreview** installed in Applications, you can also open it from there (Cmd+Tab or Applications folder).

## Widget preview

After the app is running: use **"Preview widget"** on the login screen, or go to `#/widget-preview` to see Small, Medium, and Large widget previews.

## Xcode vs Filo Desktop

| App | How to preview |
|-----|----------------|
| **Filo iOS** (iPhone/iPad + widget) | Xcode → open `filo-ios` project → run on simulator or device |
| **Filo Desktop** (macOS/Windows) | Terminal → `cd filo-desktop` → `pnpm electron:dev` |

You can **open the `filo-desktop` folder in Xcode** (File → Open → select the folder) to browse or search code, but Xcode will not build or run it. Use the terminal commands above to run and preview the desktop app.

## Requirements

- Node.js >= 20
- pnpm (`npm install -g pnpm` if needed)
