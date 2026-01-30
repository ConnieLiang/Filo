# Filo Icons

**Total: 183 icons**

**Source:** [Figma Components](https://www.figma.com/design/Pmns0wqmroGCQmqFPeSrwd/%F0%9F%AB%9A-Components?node-id=3-950)

## Location

```
Resources/Icons/Library/
```

## Categories

| Category | Count | Examples |
|----------|-------|----------|
| **Navigation** | 20 | backward, menu, search, expand, collapse |
| **Actions** | 27 | star, archive, delete, share, checkmark |
| **Email** | 29 | inbox, compose, reply, forward, send-email, sent, scheduled |
| **Labels** | 6 | label, label-important, label-gmail |
| **AI** | 13 | ai-main, generate-ai, summary, translate |
| **Status** | 14 | info, error, loading, notification |
| **Media** | 14 | play, pause, microphone, volume |
| **Files** | 5 | file, pdf, zip, document |
| **Formatting** | 14 | bold, italic, link, align, bulletlist |
| **Window** | 5 | fullscreen, minimize, floating |
| **Settings** | 15 | settings, theme, privacy, security |
| **Account** | 5 | signout, switch, filoplus |
| **Time** | 5 | clock, calendar, history |
| **Social** | 5 | twitter, discord, telegram |
| **Feedback** | 10 | support, chat, changelog |

## Naming Convention

```
Property 1=[icon-name].svg
```

Examples:
- `Property 1=star-before.svg`
- `Property 1=archive.svg`
- `Property 1=send-email.svg`

## Usage

### SwiftUI (iOS)

```swift
// Standard usage
FiloIcon.icon(.starBefore)
FiloIcon.icon(.archive, size: 24)

// Quick access for common icons
FiloIcon.star       // star-before
FiloIcon.archive    // archive
FiloIcon.trash      // delete
FiloIcon.send       // send-email
FiloIcon.ai         // ai-main
```

### HTML

```html
<img src="Resources/Icons/Library/Property 1=star-before.svg" width="24" height="24">
```

## Full Icon List

### Navigation (20)
`backward` `previous` `next` `menu` `menu-collapse` `menu-expand` `close-minimal` `close-strong` `close-weak` `expand` `collapse` `more-horizontal` `more-vertical` `search` `search-ai` `filter` `smartfilter` `scrollup` `arrow-dual-left` `arrow-dual-right`

### Actions (27)
`star-before` `star-after` `archive` `delete` `delete-permanently` `share` `dopy` `edit` `pencil` `download` `save` `refresh` `reorder` `swipe` `insert` `add` `add-circle` `subtract` `minus-circle` `checkmark` `check-circle` `check-circle-1` `checkbox-checked` `checkbox-unchecked` `checkbox-mono` `select-circle`

### Email (27)
`inbox-before` `inbox-after` `envelope` `envelope-check` `envelop-ai` `read` `unread` `compose` `draft` `allmail` `reply` `reply-mini` `reply-line` `reply-all` `replyall-mini` `replyall-line` `forward` `forward-1` `forward-mini` `forward-line` `send-email` `send-message` `attachment` `spam` `discard` `markasdone`

### AI (13)
`ai-main` `ai-2nd` `generate-ai` `summary` `proofread` `translate` `lightbulb` `longer` `shorter` `stytle` `professional` `friendly` `sad`

### Status (14)
`info` `error` `question` `loading` `todo` `todo-off` `like` `notification-on` `notification-off` `thumbsup-before` `thumbsup-after` `thumbsdown-before` `thumbsdown-after`

### Media (14)
`microphone` `microphone-circle` `play` `pause` `stop` `video-pause` `video-replay` `Volumn_Off` `Volumn_Low` `Volumn_Medium` `Volumn_High` `audio` `image` `camera`

### Formatting (14)
`boldtext` `italic` `underline` `strikethrough` `link` `link-external` `align-left` `align-center` `align-right` `bulletlist` `numberlist` `bullet` `format` `fontsize`

### Settings (15)
`settings` `customize` `theme` `darkmode` `lightmode` `language` `privacy` `security` `encryption` `billing` `signature` `shortcut` `eye` `eye-slash` `block`
