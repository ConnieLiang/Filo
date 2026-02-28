# FILO-1508 — Pre-Reply Draft Generation for Simple Emails

> 简单邮件生成预回复草稿

| Field | Value |
|-------|-------|
| Jira | FILO-1508 (parent), FILO-1515 (iOS), FILO-1514 (Mac) |
| Reporter | 黄小文 HuangXiaowen |
| Status | Design Completed |
| Priority | Medium |
| Platforms | iOS, macOS |
| Filo Feature | Instant Write |

---

## Why This Matters

This feature directly maps to Filo's **Instant Write** capability:

> "Assists with replies without taking over the user's voice. Designed for speed and clarity. Helps users respond *appropriately*, not eloquently for no reason."

**User pain:** Replying to simple emails (confirmations, scheduling, quick questions) still requires users to context-switch into writing mode. For Filo's target users — immigrants, students, foreign merchandisers — this friction is amplified by language barriers and decision fatigue.

**Product principle alignment:**
- Reduces cognitive friction (core principle #1)
- AI as infrastructure — draft appears quietly, no prompting required (principle #2)
- Opinionated defaults — Filo picks a reasonable reply, user just approves (principle #3)

---

## What We Know

### From the Requirements Doc
- Feishu wiki: https://xd.feishu.cn/wiki/WTrTwfVNTiICNOk5YV3cGfcKn6c
- Prototypes provided for both iOS and macOS

### Design Progress
- **iOS design (FILO-1515):** Figma link posted — https://www.figma.com/design/7tXBqwb5MkT6wIwnjgeA4g/Mobile?node-id=6681-82938
- **Mac design (FILO-1514):** Figma link posted — https://www.figma.com/design/Q5SuGKvcf9zcwftxOEXYGf/Desktop?node-id=22359-50476

---

## Status

Design completed by 梁希 LiangXi. Figma deliverables linked above. Now in engineering handoff.

---

## Design Principles Applied

- No visual clutter — the draft suggestion feels light, not like another notification
- No gamification — no "AI saved you 30 seconds!" messaging
- No forced engagement — if user prefers to write their own reply, the feature stays invisible
- Calm UI — suggestion feels like a helpful nudge, not an eager assistant
