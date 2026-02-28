---
name: jira-ticket-triage
description: Triage Jira tickets assigned to LiangXi against Filo product principles. Use when the user asks to review, filter, triage, or manage Jira tickets, or when checking for new tickets, pushing back on bad requests, or generating design documents from validated tickets.
---

# Jira Ticket Triage for Filo

## Atlassian Connection

- Cloud ID: `16a0d84d-b1a8-46ae-9d18-beb54753917b`
- Account ID: `712020:b6ab84a3-3c60-4c99-b2a1-140bfb9bb75a`
- Site: xindong.atlassian.net
- JQL for assigned tickets: `assignee = "712020:b6ab84a3-3c60-4c99-b2a1-140bfb9bb75a" ORDER BY created DESC`

## Triage Workflow

### Step 1: Fetch Tickets

```
searchJiraIssuesUsingJql with fields: summary, description, status, issuetype, priority, created, reporter, labels, comment
```

Skip tickets that are:
- Self-reported (reporter = LiangXi)
- Already DONE
- Already in "产品设计完成" status

### Step 2: Evaluate Against Product Principles

Read `About Filo.md` for current product vision. Evaluate each ticket on:

1. **Reduces cognitive friction?** — Does it reduce thinking, or shift it elsewhere?
2. **AI as infrastructure?** — Does it keep AI quiet and in the background, or create spectacle?
3. **Opinionated defaults?** — Does it make decisions for users, or add more options/knobs?
4. **Respects attention?** — No dopamine-driven UI, no fake urgency, no dark patterns?

A ticket **fails** if it:
- Adds options/decisions/visual weight without justification
- Is a feature checklist item with no user pain behind it
- Creates chatbot-like or attention-grabbing UX
- Has been open with no requirements/description for extended time
- Turns Filo into "another inbox skin" or "do everything productivity hub"

### Step 3: Act on Each Ticket

**For bad/misaligned tickets** — Comment with pushback (EN + CH):
- State the specific principle conflict
- Explain why it doesn't solve a real user problem
- List what would be needed to reconsider (user pain evidence, research data, differentiation)
- Recommend closing if no justification exists
- If reporter responds defending the ticket, continue pushing back until they provide evidence or withdraw

**For good tickets needing more detail** — Comment with clarifying questions (EN + CH):
- Scope and definition questions
- UX flow specifics
- Edge cases
- Whatever is needed to produce a design doc engineering can build from

**For good tickets with enough material** — Generate a design doc (see Step 4)

## Comment Rules

- Always bilingual: English first, then Chinese (separated by `---`)
- Never mention Filo's target audience or demographics in comments (demographics are being updated)
- Be direct and specific — cite the exact principle being violated or supported
- No fluff, no corporate-speak, no over-explaining
- Keep it short. Ask the right question, move on. Don't write an essay.
- Tone: Stephen Colbert — confident, sharp, convincing, never aggressive. Ask the obvious question everyone's thinking, in a way that makes the person want to answer. No sarcasm, no passive aggression.
- For good tickets: friendly, acknowledge the idea briefly, then get straight to the questions
- For bad tickets: firm but respectful. State the conflict clearly, say what's needed, done.
- Never over-praise or over-qualify. "This is good" is enough. Don't write "This is a really solid and thoughtful quality-of-life improvement that addresses a real pain point..."

## Step 4: Generate Design Documents

Place documents in the `Request/` folder:

```
Request/
├── Todo/      # Validated, ready for design work
├── Doing/     # Actively being designed
└── Done/      # Design completed or ticket closed
```

### Document naming
`[TICKET-KEY] - Short Title.md`

### Document template

```markdown
# [TICKET-KEY] — [Title]

> [Chinese title if applicable]

| Field | Value |
|-------|-------|
| Jira | [ticket keys] |
| Reporter | [name] |
| Status | [status] |
| Priority | [priority] |
| Platforms | [platforms] |
| Filo Feature | [mapped Filo feature if applicable] |

---

## Why This Matters

[How this aligns with Filo's principles. What user pain it solves.]

---

## What We Know

[Requirements docs, prototype links, Figma links, existing comments.]

---

## Open Questions

[Unanswered questions blocking design finalization.]

---

## Proposed Design Direction

[Preliminary design approach based on Filo's principles.]

---

## Design Constraints

[Non-negotiable constraints from Filo's product principles.]

---

## Next Steps

[Concrete action items.]
```

## Slack-Originated Tickets

Tickets created by the Filo Design Bot via Slack DM have these markers:
- Description ends with `---\nSubmitted by [name] via Slack DM`
- A design doc was auto-generated in `Request/Todo/` at creation time
- These tickets still need full triage — the bot only captures the request, it does not evaluate it

When triaging Slack-originated tickets:
1. The auto-generated doc in `Request/Todo/` is a skeleton — update it with full triage content if approved
2. If the ticket is rejected, move/delete the auto-generated doc and comment on the Jira ticket as usual
3. The submitter was already notified in Slack DM — no need to duplicate that notification

## Monitoring

When asked to check tickets or monitor responses:
1. Re-fetch tickets with the JQL above
2. Check for new comments on previously pushed-back tickets (especially FILO-788)
3. If reporter responds defending a pushed-back ticket without evidence, escalate the pushback
4. If reporter provides solid evidence, re-evaluate and potentially generate a design doc
