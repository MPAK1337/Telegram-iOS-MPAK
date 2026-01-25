# MPAK Mod - Integration Guide

## Overview

MPAK Mod adds two key features to Swiftgram/Telegram-iOS:
1. **Anti-Delete** - Deleted messages remain visible with pink-purple gradient highlight
2. **Edit History** - View all previous versions of edited messages via context menu

## Files Added

All MPAK files are in: `Swiftgram/Sources/MPAK/`

| File | Purpose |
|------|---------|
| `MPAKSettings.swift` | Settings, localization, gradient colors |
| `MPAKDeletedMessages.swift` | Anti-delete logic, edit history management |
| `MPAKMessageAttribute.swift` | Custom MessageAttribute for Postbox storage |

## Patched Files

### 1. AccountStateManagementUtils.swift
**Path:** `submodules/TelegramCore/Sources/State/AccountStateManagementUtils.swift`

**Changes:**
- `DeleteMessagesWithGlobalIds` case: Added MPAKDeletedMessages.markMessagesAsDeleted hook
- `DeleteMessages` case: Added MPAKDeletedMessages.markMessagesAsDeleted hook  
- `EditMessage` case: Added MPAKDeletedMessages.saveEditHistory hook

### 2. ChatInterfaceStateContextMenus.swift
**Path:** `submodules/TelegramUI/Sources/ChatInterfaceStateContextMenus.swift`

**Changes:**
- Added import for MPAK module
- Added "History" button to context menu for messages with edit history

### 3. SGSettingsController.swift
**Path:** `Swiftgram/SGSettingsUI/Sources/SGSettingsController.swift`

**Changes:**
- Added `mpak` case to SGControllerSection enum
- Added `mpakAntiDelete` and `mpakAntiEdit` to SGBoolSetting enum
- Added MPAK settings section with toggles and developer info
- Added handlers for MPAK settings toggles

## UI for Deleted Messages (Manual Step)

To add the gradient highlight for deleted messages, modify `ChatMessageBubbleItemNode.swift`:

**Path:** `submodules/TelegramUI/Components/Chat/ChatMessageBubbleItemNode/Sources/ChatMessageBubbleItemNode.swift`

Add in the background rendering section:

```swift
import MPAK

// In the message background setup, check if message is deleted:
if MPAKDeletedMessages.isMessageDeleted(message) {
    // Add gradient overlay
    let gradientLayer = MPAKSettings.DeletedMessageGradient.makeGradientLayer(frame: backgroundFrame)
    self.layer.insertSublayer(gradientLayer, at: 0)
}
```

## Building

The GitHub Actions workflow is configured to build unsigned IPA:

1. Push changes to master branch
2. Go to Actions tab
3. Wait for "Build Swiftgram IPA" workflow to complete
4. Download the unsigned IPA artifact

## Signing with ESign

1. Download the unsigned IPA from GitHub Actions artifacts
2. Open ESign app on iPhone
3. Import the IPA file
4. Sign with your certificate
5. Install and enjoy MPAK features!

## Settings

MPAK section appears at the bottom of Swiftgram settings:
- **Anti-Delete** toggle - Keep deleted messages visible
- **Edit History** toggle - Save message versions before edits
- Developer info: MPAK, https://t.me/naebx

## How It Works

### Anti-Delete
1. When Telegram receives delete command (server or local)
2. MPAKDeletedMessages intercepts the deletion
3. Instead of removing, it marks message with `isDeleted: true` flag
4. Message stays in database with special attribute
5. UI renders it with gradient highlight (when implemented)

### Edit History
1. When message is edited, old version is saved to MPAKMessageAttribute.editHistory
2. Array stores: text, date, media description
3. Context menu shows "History" button for messages with history
4. Tapping shows alert with all previous versions

## Gradient Colors

```
Start: #FF6B9D (pink) → End: #C44AFF (purple)
Opacity: 30%
Direction: Top-left to bottom-right diagonal
```

## Contact

Developer: **MPAK**  
Telegram: https://t.me/naebx
