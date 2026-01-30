# Filo

> Filo helps people understand, act on, and move past email without wasting attention.

## Overview

**Filo** is an AI-native email client designed to reduce cognitive load, not add features for the sake of features.

Filo does not try to replace email. It tries to make email *behave*.

The product focuses on helping people:
- Understand what matters
- Decide what to act on
- Respond with less effort
- Let go of the rest

**Core belief:**
> Email overload is not a volume problem. It's a decision fatigue problem.

---

## The Sart of Filo

No Silicon Valley buzz, no big stages — just a small team that loves building digital tools to make life a little easier. When AI took off, we saw a chance to make something simpler, smarter, more human. So we built Filo — not to change the world, just to make email suck less.

---

## What Filo Is (And Is Not)

### Filo **is**
- An AI-first email client
- A decision-support layer on top of email
- A tool for busy professionals who already get too much input
- Opinionated about clarity, relevance, and restraint

### Filo **is not**
- Another inbox skin
- A feature checklist
- A "do everything" productivity hub
- A chatbot pretending to be a product

---

## Target Users

Filo is built for people who:
- Live in their inbox
- Are interrupted constantly
- Care about clarity more than customization
- Want less thinking, not more automation knobs

**Typical personas:**
- Immigrants
- Students
- Financial Advisors
- Small Business Owners
- Foreign Merchandisers
- Knowledge workers with high email volume and low tolerance for noise

---

## Core Product Principles

1. **Reduce cognitive friction**
   - Every feature must reduce thinking, not shift it elsewhere.

2. **AI as infrastructure, not spectacle**
   - AI runs quietly in the background.
   - No forced prompts. No "talk to your inbox" gimmicks.

3. **Opinionated defaults**
   - Filo makes decisions so users don't have to.
   - Power users can go deeper, but only if they choose to.

4. **Respect attention**
   - No dopamine-driven UI.
   - No fake urgency.
   - No dark patterns.

---

## Key Features

### Auto-Summary
Condenses long emails and threads into short, readable summaries. Optimized for scanning, not reading. Designed to answer: *"Do I need to care?"*

### Smart Labels
Automatically categorizes emails by intent and importance:
- Action required
- FYI
- Waiting on others
- Low priority

Reduces manual sorting and filtering.

### Smart Filter
Lets users apply rules at scale (e.g. last 100 emails). Focuses on intent, not sender or keyword hacks. Designed for cleanup and ongoing sanity.

### Task Agent
Extracts actionable items from emails. Surfaces what actually needs follow-up. Keeps tasks close to context, not in a separate universe.

### Instant Write
Assists with replies without taking over the user's voice. Designed for speed and clarity. Helps users respond *appropriately*, not eloquently for no reason.

---

## Monetization

### Free Plan
- Free forever
- Core functionality available
- Designed to be genuinely usable, not a teaser

### Plus / Pro
- Higher AI usage
- Advanced automation and scaling features
- For users who live in Filo daily

Pricing language is intentionally calm: no pressure, no artificial limits. Upgrade when it actually helps.

---

## Tech Stack

| Platform | Language/Framework | Notes |
|----------|-------------------|-------|
| iOS      | Swift / SwiftUI   |       |
| macOS    | Swift / SwiftUI   |       |
| Android  |                   |       |
| Windows  |                   |       |

## Project Structure

```
Filo/
├── Shared/              # Cross-platform code (models, view models, business logic)
├── iOS/                 # iOS-specific code
├── macOS/               # macOS-specific code
├── Android/             # Android-specific code
├── Windows/             # Windows-specific code
├── Resources/           # Shared assets (icons, colors, images)
├── Design Guidelines/   # Visual design system (colors, typography, icons, components)
└── Tests/               # Unit and integration tests
```

## Design Guidelines

See the `Design Guidelines/` folder for the complete visual design system:

- **Colors** — 25 color tokens with light/dark mode variants
- **Typography** — Type scale and platform fonts (SF Pro, Roboto, Segoe UI)
- **Icons** — Icon system guidelines
- **Components** — UI component specifications

---

## Competitive Positioning

Filo sits between traditional email clients (Gmail, Outlook) and over-engineered productivity tools.

**Differentiation:**
- Less configuration
- More judgment
- AI that works *for* the user, not *at* the user

---

## Long-Term Vision

Filo aims to become:
- The calmest place in a chaotic workday
- A trusted layer between people and incoming information
- A product that scales with responsibility, not anxiety

**North star:**
> Help people feel done — not busy.

---

## Getting Started

### Prerequisites
- Xcode 15+ (for iOS/macOS)

### Setup
1. Clone the repository
2. Open the Xcode project
3. Build and run

---

## Current Status

- [ ] iOS MVP
- [ ] macOS MVP
- [ ] Android MVP
- [ ] Windows MVP

---

## Internal Reminder

If a feature:
- Adds options
- Adds decisions
- Adds visual weight
- Adds explanation

…it needs to justify itself.

**Less is the feature.**