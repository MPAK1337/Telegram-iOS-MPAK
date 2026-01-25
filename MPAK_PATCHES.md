# MPAK Mod - Инструкции по патчам

Для полной работы функций нужно применить патчи к исходному коду Swiftgram.

## 1. Хук удаления сообщений

### Файл: `submodules/TelegramCore/Sources/State/AccountStateManagementUtils.swift`

Найди функцию обработки удаления сообщений с сервера (обычно обрабатывает `Api.Update.deleteMessages`).

**Добавить перед удалением:**
```swift
import MPAK // или добавь файлы в таргет

// Внутри обработчика deleteMessages:
let remainingIds = MPAKDeletedMessages.markMessagesAsDeleted(
    globalIds: messageIds,
    transaction: transaction
)
// Продолжить удаление только для remainingIds
```

### Файл: `submodules/TelegramCore/Sources/State/DeleteMessages.swift`

Найди функцию `_internal_deleteMessages` или аналог.

**Добавить в начале:**
```swift
let remainingIds = MPAKDeletedMessages.markMessagesAsDeleted(
    ids: ids,
    transaction: transaction
)
guard !remainingIds.isEmpty else { return }
// Продолжить с remainingIds вместо ids
```

## 2. Хук редактирования сообщений

### Файл: `submodules/TelegramCore/Sources/State/ApplyUpdateMessage.swift`

Найди место где применяется редактирование сообщения.

**Добавить перед обновлением:**
```swift
if let existingMessage = transaction.getMessage(messageId) {
    MPAKDeletedMessages.saveEditHistory(
        messageId: messageId,
        originalText: existingMessage.text,
        transaction: transaction
    )
}
```

## 3. Кнопка "История" в контекстном меню

### Файл: `submodules/TelegramUI/Sources/Chat/ChatMessageContextMenuActions.swift`

Найди где формируется массив actions для контекстного меню.

**Добавить новый action:**
```swift
// После других actions, перед return
if message.hasEditHistory {
    actions.append(.action(ContextMenuActionItem(
        text: MPAKSettings.Strings.historyButtonTitle,
        icon: { theme in
            return generateTintedImage(image: UIImage(bundleImageName: "Chat/Context Menu/History"), color: theme.contextMenu.primaryColor)
        },
        action: { [weak self] c, a in
            // Показать историю правок
            self?.presentEditHistory(for: message)
            a(.default)
        }
    )))
}
```

## 4. Секция MPAK в настройках

### Файл: `Swiftgram/Sources/SGSettingsController.swift`

Найди где добавляются секции настроек (обычно массив sections).

**Добавить новую секцию:**
```swift
// MARK: - MPAK Section
let mpakSection = ItemListSectionItem(
    // ... конфигурация секции
)

// Переключатель анти-удаления
let antiDeleteItem = ItemListSwitchItem(
    presentationData: presentationData,
    title: MPAKSettings.Strings.antiDeleteTitle,
    value: MPAKSettings.antiDeleteEnabled,
    updated: { value in
        MPAKSettings.antiDeleteEnabled = value
    }
)

// Переключатель истории правок
let antiEditItem = ItemListSwitchItem(
    presentationData: presentationData,
    title: MPAKSettings.Strings.antiEditTitle,
    value: MPAKSettings.antiEditEnabled,
    updated: { value in
        MPAKSettings.antiEditEnabled = value
    }
)

// О разработчике
let aboutItem = ItemListDisclosureItem(
    presentationData: presentationData,
    title: MPAKSettings.Strings.aboutDeveloper,
    label: "",
    action: {
        openUrl(MPAKSettings.developerTelegram)
    }
)
```

## 5. UI отображения удалённых сообщений

### Файл: `submodules/TelegramUI/Sources/Chat/ChatMessageBubbleItemNode.swift`

Найди где устанавливается фон bubble.

**Добавить проверку:**
```swift
if message.isDeletedByMPAK {
    // Градиентный фон розово-фиолетовый
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [
        UIColor(rgb: 0xFF6B9D).cgColor,  // Розовый
        UIColor(rgb: 0xC44AFF).cgColor   // Фиолетовый
    ]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    // Применить к фону
}
```

---

## Порядок применения

1. Сначала добавь Swift-файлы MPAK в проект
2. Добавь их в соответствующие таргеты (TelegramCore, Swiftgram)
3. Примени патчи по порядку
4. Собери проект

## Примечания

- Точные имена функций могут отличаться в разных версиях
- Используй поиск по ключевым словам: `deleteMessages`, `updateMessage`, `contextMenu`
- После каждого патча проверяй компиляцию

---

**Разработчик:** MPAK • [@naebx](https://t.me/naebx)
