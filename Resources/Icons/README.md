# Filo Icons

**Total: 184 icons**

**Source:** [Figma Components](https://www.figma.com/design/Pmns0wqmroGCQmqFPeSrwd/%F0%9F%AB%9A-Components?node-id=3-950)

## Location

```
Resources/Icons/Library/
```

## Naming Convention

```
Property 1=[icon-name].svg
```

Examples:
- `Property 1=star-before.svg`
- `Property 1=send-email.svg`
- `Property 1=customize.svg`

## Categories

| Category | Count | Examples |
|----------|-------|----------|
| **Navigation** | 21 | menu, search, expand, collapse, goforward, gobackward |
| **Actions** | 28 | star, archive, delete, share, checkmark, copy, edit |
| **Email** | 30 | inbox, compose, reply, forward, send-email, sent, scheduled |
| **Labels** | 7 | label, label-important, label-gmail, label-promotions |
| **AI** | 13 | ai-main, generate-ai, summary, translate, proofread |
| **Status** | 15 | info, error, loading, notification, thumbsup, thumbsdown |
| **Media** | 15 | play, pause, microphone, volume, camera, image |
| **Files** | 6 | file, pdf, zip, document-1, document-2 |
| **Formatting** | 14 | bold, italic, link, align, bulletlist, numberlist |
| **Window** | 5 | fullscreen-enter, fullscreen-exit, minimizescreen, window-floating |
| **Settings** | 16 | settings, customize, theme, privacy, security, signature |
| **Account** | 4 | signout, switch, filoplus, filoplus-mono |
| **Time** | 4 | clock, calendar, history, scheduled |
| **Social** | 7 | twitter, discord, telegram, youtube, imessage, google |
| **Feedback** | 10 | support, chat, changelog, reportissue, clap, coffee |

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

### CSS (Inline SVG)

```css
.icon {
    width: 24px;
    height: 24px;
    color: currentColor;
}
```

## Full Icon List

### Navigation (21)
`gobackward` `goforward` `previous` `next` `menu` `menu-collapse` `menu-expand` `close-minimal` `close-strong` `close-weak` `expand` `collapse` `more-horizontal` `more-vertical` `search` `search-ai` `filter` `smartfilter` `scrollup` `arrow-dual-left` `arrow-dual-right`

### Actions (28)
`star-before` `star-after` `archive` `delete` `delete-permanently` `share` `copy` `edit` `pencil` `download` `save` `refresh` `reorder` `swipe` `insert` `add` `add-circle` `subtract` `minus-circle` `checkmark` `check-circle` `check-fillcircle` `checkbox-checked` `checkbox-unchecked` `checkbox-mono` `select-circle` `cancel` `cursor-begin` `cursor-end`

### Email (30)
`inbox-before` `inbox-after` `envelope` `envelope-check` `envelope-ai` `read` `unread` `compose` `draft` `allmail` `reply` `reply-mini` `reply-line` `reply-all` `replyall-mini` `replyall-line` `forward` `forward-mini` `forward-line` `send-email` `send-message` `attachment` `spam` `discard` `markasdone` `sent` `scheduled` `clearchat` `signature`

### Labels (7)
`label` `label-important` `label-unimportant` `label-gmail` `label-promotions` `label-updates`

### AI (13)
`ai-main` `ai-2nd` `generate-ai` `summary` `proofread` `translate` `lightbulb` `longer` `shorter` `style` `professional` `friendly` `sad`

### Status (15)
`info` `error` `question` `loading` `todo` `todo-off` `like` `notification-on` `notification-off` `thumbsup-before` `thumbsup-after` `thumbsdown-before` `thumbsdown-after` `clap`

### Media (15)
`microphone` `microphone-circle` `play` `pause` `stop` `video-pause` `video-replay` `volume-off` `volume-low` `volume-medium` `volume-high` `audio` `image` `camera`

### Files (6)
`file` `pdf` `zip` `document-1` `document-2` `attachment`

### Formatting (14)
`boldtext` `italic` `underline` `strikethrough` `link` `link-external` `align-left` `align-center` `align-right` `bulletlist` `numberlist` `bullet` `format` `fontsize`

### Window (5)
`fullscreen-enter` `fullscreen-exit` `minimizescreen` `window-floating` `window-sidebar`

### Settings (16)
`settings` `customize` `theme` `darkmode` `lightmode` `language` `privacy` `security` `encryption` `billing` `signature` `shortcut` `eye` `eye-slash` `block` `terms`

### Account (4)
`signout` `switch` `filoplus` `filoplus-mono`

### Time (4)
`clock` `calendar` `history` `scheduled`

### Social (7)
`twitter` `discord` `telegram` `youtube` `imessage` `google` `appicon`

### Feedback (10)
`support` `chat` `changelog` `reportissue` `clap` `coffee` `gift` `like`

---

*Last updated: January 2026*
