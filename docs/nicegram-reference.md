# Nicegram references

## Workflow: `.github/workflows/master.yml`

```yaml
name: Master Release

on:
  push:
    branches:
      - master

jobs:
  build:
    runs-on: macos-26
```

The workflow uses Fastlane (`fastlane master_build`) and creates a GitHub release with IPA + dSYMs. It also configures multiple secrets (App Store Connect API, signing, cache, and Telegram bot tokens).

## Commit: `4ad4741c1b3da7d89b4e889b637a6a452893eac2`

The commit removes Nicegram deleted/edited message UI toggles and related strings:

- `NicegramSettingsController.swift`: removed the `showDeletedMessages` toggle and its action.
- `NiceLocalizable.strings`: removed `ShowDeletedMessages`, `ShowOriginalText`, `UndoShowOriginalText`.
- `ChatHistoryEntriesForView.swift`: removed filtering that hid deleted messages when `showDeletedMessages` is disabled.
- `ChatInterfaceStateContextMenus.swift`: removed deleted-message pin restrictions and original-text context menu actions.

