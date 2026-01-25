# MPAK Mod для Swiftgram

Мод с функциями Anti-Delete и Edit History для Swiftgram/Telegram-iOS.

## Возможности

### Anti-Delete (Анти-Удаление)
- Сохраняет удалённые сообщения вместо их удаления
- Удалённые сообщения отображаются с:
  - Пониженной прозрачностью (opacity 0.6)
  - Иконкой корзины в углу
- Фильтрация по типу чата (личные, группы, каналы, боты)

### Edit History (История Редактирования)
- Сохраняет все версии отредактированных сообщений
- Просмотр через контекстное меню (долгое нажатие → "История")
- Сохраняет текст, дату и описание медиа

### Настройки
- Отдельные тогглы для каждой функции
- Фильтры типов чатов (множественный выбор)
- Кнопка "Удалить все сохранённые"
- Локализация: English / Русский

## Структура файлов

```
Swiftgram/Sources/MPAK/
├── BUILD                           # Bazel build file
├── MPAKMessageAttribute.swift      # MessageAttribute с флагами isDeleted и editHistory
├── MPAKSettings.swift              # Настройки мода
├── MPAKDeletedMessages.swift       # Логика anti-delete и edit history
└── Patches/
    ├── SGSettingsController.swift.patch        # UI настроек
    └── ChatMessageBubbleItemNode.swift.patch   # UI удалённых сообщений
```

## Уже применённые патчи

Эти файлы уже изменены в репозитории:

1. **AccountStateManagementUtils.swift** - хуки для сохранения удалённых/редактированных
2. **ChatInterfaceStateContextMenus.swift** - кнопка "История" в контекстном меню
3. **SGLocalizable.strings** (en, ru) - локализация MPAK строк

## Патчи для ручного применения

### 1. SGSettingsController.swift.patch

Добавляет секцию MPAK в настройки Swiftgram:
- Тогглы Anti-Delete и Edit History
- Фильтры типов чатов
- Кнопка удаления всех сохранённых

Применить к: `Swiftgram/SGSettingsUI/Sources/SGSettingsController.swift`

### 2. ChatMessageBubbleItemNode.swift.patch

Добавляет визуальное отображение удалённых сообщений:
- Пониженная прозрачность (0.6)
- Иконка корзины

Применить к: `submodules/TelegramUI/Sources/Chat/ChatMessageBubbleItemNode.swift`

## Сборка

### GitHub Actions (Рекомендуется)

1. Перейдите в Actions → Build MPAK Mod Unsigned IPA
2. Нажмите "Run workflow"
3. Скачайте IPA из Artifacts
4. Подпишите через ESign на iPhone

### Локальная сборка (macOS)

```bash
# Клонировать репозиторий
git clone --recursive https://github.com/MPAK1337/Telegram-iOS-MPAK.git
cd Telegram-iOS-MPAK

# Установить зависимости
brew install bazelisk

# Собрать IPA (без подписи)
python3 build-system/Make/Make.py \
    build \
    --configurationPath="build-system/appstore-configuration.json" \
    --buildNumber=1 \
    --disableProvisioningProfiles \
    --disableCodesign
```

## Подпись через ESign

1. Установите ESign на iPhone (через AltStore или Scarlet)
2. Загрузите unsigned IPA на телефон
3. В ESign: импортируйте сертификат и provisioning profile
4. Подпишите IPA и установите

## Ограничения

- Anti-Delete работает только когда приложение запущено или в фоне
- Если приложение убито (killed), сообщения уже удалены с сервера
- Данные сохраняются в базе Postbox (переживают перезапуск)

## Разработчик

- Telegram: [@naebx](https://t.me/naebx)
- Версия: 1.0.0
