# FILO-1647 — Redesign AI Tab (iOS)

> 【iOS】Re-design AI tab

| Field | Value |
|-------|-------|
| Jira | FILO-1647 |
| Reporter | 梁希 LiangXi (self) |
| Status | Open |
| Priority | Medium |
| Platform | iOS |
| Filo Feature | AI Tab (core navigation) |

---

## Problem Statement

> "The AI tab is painfully unsexy. It does nothing to spark curiosity or motivate continued use."

The current AI tab fails on two levels:
1. **Engagement** — It doesn't communicate value or invite exploration
2. **Utility** — It doesn't surface AI capabilities in a way that feels natural to email workflows

This matters because the AI tab is where Filo's differentiation lives. If it feels dead, users won't discover the features that make Filo worth using.

---

## Design Principles for the Redesign

Drawing from Filo's product principles:

### 1. Show results, not process
The AI tab should surface **what AI has done for you**, not ask you to do things with AI.
- Auto-summaries already generated
- Smart labels already applied
- Tasks already extracted
- Drafts already suggested

### 2. Calm, not flashy
The redesign should feel like opening a well-organized desk, not a dashboard full of metrics.
- No counters ("AI processed 47 emails today!")
- No animations for the sake of delight
- Information density should be scannable in 3 seconds

### 3. Action-oriented
Every element should lead to a clear next step:
- "Here's what needs your attention" → tap to act
- "Here's what Filo handled" → tap to review (optional)
- "Here's what you can let go" → already archived/labeled

### 4. Contextual, not generic
The tab should feel different depending on what's in the inbox right now, not show the same static layout every time.

---

## Potential Structure

### Section 1: Needs Attention
- Emails with extracted action items
- Emails waiting for your reply (with suggested drafts)
- High-priority items the AI flagged

### Section 2: Handled
- Emails auto-labeled and sorted
- Low-priority items moved out of the way
- Newsletters/promotions summarized and grouped

### Section 3: Insights (optional, low priority)
- Patterns in email behavior (weekly, not real-time)
- Suggestions for filters or rules based on behavior
- Keep this minimal — it should justify its existence

---

## Constraints

- Must follow Filo's design system (see `Design Guidelines/`)
- iOS-first (SwiftUI)
- No onboarding required — the tab should be self-explanatory
- No "empty state" that says "AI is learning" — always show something useful, even on day one
- Performance: tab should load instantly, no spinners

---

## Open Questions

- [ ] What AI capabilities are currently live vs. planned? (Need to design for what exists, not vaporware)
- [ ] Is the AI tab a separate navigation destination, or should it be integrated into the inbox view?
- [ ] Current screenshot/recording of the existing AI tab for reference
- [ ] What does the competitive landscape look like? (How do Spark, Edison Mail, etc. handle their AI surfaces?)

---

## Next Steps

1. Audit current AI tab implementation
2. Sketch 2-3 layout concepts based on the structure above
3. Review against design system
4. Prototype in Figma (iOS)
