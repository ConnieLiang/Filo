# CLAUDE.md — Rules for Automated Workflows

This repo is Filo's design system source of truth. These rules apply to all automated agents operating in this repo, including CI workflows.

## Required Reading

Before making any change, read these files in order:

1. `principles.md` — Filo's product design principles
2. `SKILL.md` — Design system enforcement rules (tokens, typography, spacing, radius, components)

Every change must be consistent with both documents.

## Protected Files — Do Not Edit

The following files may **never** be modified directly by automated workflows:

- `tokens.json`
- `principles.md`
- `SKILL.md`
- `platform-notes/*.md`

If a review comment requests a change to any of these files:

1. **Do not edit the file.**
2. **Create a GitHub Issue** instead, with:
   - Title: `[Design Review] {short description of requested change}`
   - Body: the reviewer's comment, the file and line in question, and your assessment of whether the change aligns with `principles.md`
   - Label: `design-review`
3. Reply to the review comment: "This file is protected. I've opened an issue for the design team to review: #{issue_number}"

## Feature Specs — Guarded Edits

Files in `features/*.md` may be edited, but only if:

- The change is consistent with `principles.md` (all four principles)
- Token values referenced in the edit exist in `tokens.json` — never invent new values
- The edit does not remove or weaken platform-specific notes (iOS, Android, Desktop sections)

If a requested change conflicts with Filo's principles, do not make the edit. Instead, create an issue explaining the conflict.

## General Rules

- Never add hardcoded color hex values that aren't in `tokens.json`
- Never introduce generic framework defaults (Tailwind gray-*, Material default colors, Inter/Arial fonts)
- Never remove i18n strings or replace bilingual copy with English-only
- Keep all edits minimal and scoped to the review comment — do not refactor surrounding content
