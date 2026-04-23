# Filo Colors

Standalone interactive scheme catalog for Filo Desktop.

## What it does

- Loads color schemes from `data/schemes.manifest.json`
- Renders one scheme at a time with light and dark token details
- Supports edit mode with live swatch adjustment
- Updates hex and RGB values immediately
- Exports all current scheme data as a versioned JSON file

## How to add more schemes

1. Add a new JSON file to `data/`
2. Append its filename to `data/schemes.manifest.json`
3. Reload the page

The page is built to scale to around 10 schemes without changing the layout model.

## Expected scheme shape

Preferred:

- `name`
- `version`
- `notes`
- `tokenReplacements.color`

Supported fallback:

- `color`

## How to open it

Do not open this page via `file://`.

Serve the repo root with a local static server, for example:

```bash
cd /Users/connieliang/Documents/Codex/2026-04-22-clone-this-repo-https-github-com
python3 -m http.server 4173
```

Then open:

- `http://localhost:4173/tools/colors/`
