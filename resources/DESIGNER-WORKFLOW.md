# Designer workflow: assets in filo-design

This doc is for **you as the designer**: how to add and maintain icons, illustrations, and other resources in filo-design so they ship cleanly to all Filo apps.

---

## Your role

- **You own** what goes in `resources/`: icons, illustrations, and future asset types.
- **You decide** naming, categorization, and when something is ready to ship.
- **Engineering** consumes from here (submodule or sync); they don’t invent asset names or locations.

Keeping assets in filo-design keeps design the single source of truth and makes your decisions visible in one place.

---

## Adding a new icon

1. **Export from Figma** (or add SVG) into `resources/icons/`.
2. **Name the file** `{name}.svg` in kebab-case (e.g. `empty-inbox.svg`, `storage.svg`).
3. **Open `resources/icons/icons.json`** and add the icon name to the right category (or add a new category if it’s a new type).
4. If the icon has an **on/off or before/after** state, add the pair to `stateVariants`.
5. **Commit** (e.g. “Add storage icon”) and push. Done.

No need to touch app code for the file itself; apps that consume filo-design will pick up the new file. If an app still points at the old Filo repo path, that’s an engineering task to switch to filo-design.

---

## Adding an illustration

1. Create `resources/illustrations/` if it doesn’t exist.
2. Add the file with a clear name, e.g. `empty-inbox.svg` or `onboarding-step-2.png`. For PNG, provide 2x (and 3x if needed for iOS).
3. Add a short note in `resources/illustrations/README.md`: name, format, where it’s used (e.g. “Empty state for Inbox”).
4. Commit and push.

Later we can add an `illustrations.json` catalog like icons if the set grows.

---

## Changing an existing icon

1. Replace the SVG in `resources/icons/{name}.svg` (keep the same filename so apps don’t break).
2. If the **meaning or usage** changes, update `icons.json` (category or description) and/or `resources/icons/README.md`.
3. Commit with a message like “Update close icon (stronger weight)”.

---

## Naming conventions

| Asset type   | Convention   | Example                |
|-------------|--------------|------------------------|
| Icons       | kebab-case   | `inbox-before.svg`     |
| Illustrations | kebab-case | `empty-inbox.svg`      |
| Multi-state | `-before` / `-after`, `-on` / `-off` | `star-before.svg`, `notification-off.svg` |

Stick to one naming style so engineering can rely on it in code and config.

---

## When to update catalogs

- **icons.json** — When you add an icon, remove one, or add a state pair. Keeps “what exists” and “where it lives” in one place.
- **README files** — When you add a new asset type (e.g. illustrations), add a section so the next designer (or you in 6 months) knows the rules.

---

## Checklist before you commit

- [ ] File is in the right folder (`icons/` or `illustrations/`).
- [ ] Filename is kebab-case and matches the convention above.
- [ ] Catalog (e.g. `icons.json`) is updated if you added or renamed something.
- [ ] README in that folder is updated if you changed how things are organized or used.

---

## Where design meets engineering

- **Design (you):** Add/change assets and catalogs in filo-design; name and categorize.
- **Engineering:** Point apps at filo-design (submodule or copy), use `icons.json` and paths in build/config, and don’t rename or move files without aligning with design.

If an app needs a different path or format (e.g. bundled icons with a different name), that’s a joint decision and should be documented in this repo or in the app’s design handoff.
