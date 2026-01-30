# Module Request Guide

Use this guide when asking to build a new module/feature.

---

## 1. Specify the Platform

- **iOS** (Liquid Glass style)
- **Android** (Material 3 style)
- **Both**

---

## 2. Choose the Nav Bar Variant

| Variant | Use When |
|---------|----------|
| **Read Email** | Viewing content with actions (star, archive, delete) |
| **Select Email** | Multi-select/batch actions with count |
| **Compose** | Creating/editing with close + send |
| **Subpage** | Settings, details pages with back + title |

Or describe a custom layout if none of these fit.

---

## 3. Provide Module Details

- **Module name** (e.g., "Inbox", "Email Detail", "Settings")
- **Background type**: `gradient` | `light` | `white` | `image`
- **Content description** (what goes below the nav bar)

---

## Example Requests

### Using an existing nav variant:

> Build the **Email Detail** module for **iOS**.  
> Use the **Read Email** nav bar variant.  
> Background: **blue gradient**.  
> Content: email header (sender, subject, date) and body.

### Custom nav bar:

> Build a **Search** module for **Android**.  
> Nav bar: back button (left), search input (center), filter icon (right).  
> Background: **white**.  
> Content: search results list.

---

## Quick Reference

| Resource | Location |
|----------|----------|
| iOS Nav Preview | `preview/navigation-bars-preview.html` |
| Android Nav Preview | `preview/navigation-bars-android.html` |
| Icons (181) | `Resources/Icons/Library/` |
| Icon Catalog | `Design Guidelines/Icons/icons.json` |
| Brand Color | `#22A0FB` |

---

## Nav Bar Variants Preview

### iOS (Liquid Glass)
- Glass blur effect with pills
- 44pt touch targets
- Horizontal more icon (•••)

### Android (Material 3)
- Flat surface with tonal elevation
- 48dp touch targets
- Vertical more icon (⋮)
- FAB-style send button (rounded rectangle)
