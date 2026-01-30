# Filo Icon Library

Complete icon set with 183 SVG icons organized by category.

## Source

All icons are stored locally in:
```
Resources/Icons/Library/
```

**Naming convention:** `Property 1={icon-name}.svg`

## Categories

### Navigation (13 icons)
Tab bar and navigation icons.

| Icon | Name | Usage |
|------|------|-------|
| 📥 | `inbox-before` | Inbox tab (inactive) |
| 📥 | `inbox-after` | Inbox tab (active) |
| ✅ | `todo` | To-do tab |
| ✨ | `ai-main` | AI tab |
| ✏️ | `compose` | Compose button |
| 🔍 | `search` | Search |
| ⚙️ | `settings` | Settings |

### Actions (14 icons)
Common action icons.

| Icon | Name | Usage |
|------|------|-------|
| ↩️ | `reply` | Reply to email |
| ↩️↩️ | `reply-all` | Reply all |
| ➡️ | `forward` | Forward email |
| 📦 | `archive` | Archive |
| 🗑️ | `delete` | Delete |
| ✏️ | `edit` | Edit |
| 💾 | `save` | Save |
| 📤 | `share` | Share |

### Email (13 icons)
Email-specific icons.

| Icon | Name | Usage |
|------|------|-------|
| ✉️ | `envelope` | Email |
| ✉️✓ | `envelope-check` | Verified email |
| 📨 | `send-email` | Send |
| 📬 | `sent` | Sent folder |
| ⏰ | `scheduled` | Scheduled emails |
| 📝 | `draft` | Drafts |
| ⭐ | `star-before/after` | Starred |

### AI Features (15 icons)
AI and smart feature icons.

| Icon | Name | Usage |
|------|------|-------|
| ✨ | `ai-main` | Primary AI icon |
| ✨ | `ai-2nd` | Secondary AI icon |
| 🤖 | `generate-ai` | AI generation |
| 🔍 | `search-ai` | AI search |
| 📋 | `summary` | Summarize |
| ✏️ | `proofread` | Proofread |
| 🌐 | `translate` | Translate |

### Formatting (12 icons)
Text formatting icons.

| Icon | Name | Usage |
|------|------|-------|
| **B** | `boldtext` | Bold |
| *I* | `italic` | Italic |
| <u>U</u> | `underline` | Underline |
| 🔗 | `link` | Insert link |
| ≡ | `align-left/center/right` | Text alignment |
| • | `bulletlist` | Bullet list |
| 1. | `numberlist` | Numbered list |

### Media (15 icons)
Media and file icons.

| Icon | Name | Usage |
|------|------|-------|
| 🖼️ | `image` | Image |
| 📷 | `camera` | Camera |
| ▶️ | `play` | Play |
| ⏸️ | `pause` | Pause |
| 🎤 | `microphone` | Microphone |
| 📄 | `file` | File |
| 📕 | `pdf` | PDF document |

### UI Controls (21 icons)
UI control icons.

| Icon | Name | Usage |
|------|------|-------|
| ✕ | `close-minimal/weak/strong` | Close |
| + | `add` | Add |
| − | `subtract` | Subtract |
| ✓ | `checkmark` | Checkmark |
| ☐ | `checkbox-unchecked/checked` | Checkbox |
| ⋯ | `more-horizontal/vertical` | More options |

### Settings (14 icons)
Settings and preferences icons.

| Icon | Name | Usage |
|------|------|-------|
| ⚙️ | `settings` | Settings |
| 🌙 | `darkmode` | Dark mode |
| ☀️ | `lightmode` | Light mode |
| 🔔 | `notification-on/off` | Notifications |
| 🔒 | `privacy` | Privacy |
| 🛡️ | `security` | Security |

## State Variants

Some icons have active/inactive states:

| Inactive | Active | Usage |
|----------|--------|-------|
| `inbox-before` | `inbox-after` | Tab selection |
| `star-before` | `star-after` | Starred state |
| `todo` | `todo-off` | Task completion |
| `checkbox-unchecked` | `checkbox-checked` | Selection state |
| `notification-on` | `notification-off` | Toggle state |

## Usage

### HTML/CSS
```html
<img src="Resources/Icons/Library/Property 1=inbox-before.svg" alt="Inbox">
```

### Inline SVG with dynamic color
```html
<svg fill="currentColor">
  <!-- SVG content -->
</svg>
```

### SwiftUI
```swift
Image("inbox-before")
    .renderingMode(.template)
    .foregroundColor(.filo02)
```

### React Native
```jsx
import InboxIcon from '@/assets/icons/inbox-before.svg';

<InboxIcon fill={colors.filo02} width={24} height={24} />
```

## Icon Guidelines

1. **Size:** Default 24x24px, can scale proportionally
2. **Color:** Use `currentColor` for dynamic theming
3. **Stroke:** Consistent 1.5-2px stroke weight
4. **Style:** Outline style with rounded corners
