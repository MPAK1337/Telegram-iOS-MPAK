# Swiftgram MPAK Mod

Форк Swiftgram с дополнительными функциями от MPAK.

## Функции

### Anti-Delete (Анти-удаление)
Когда кто-то удаляет сообщение, оно остаётся видимым с градиентной подсветкой.

### Edit History (История правок)
При долгом нажатии на сообщение → кнопка "История" → показывает все версии сообщения до редактирования.

## Сборка

GitHub Actions автоматически собирает unsigned IPA при каждом push.

1. Перейди в **Actions**
2. Выбери последний успешный билд
3. Скачай артефакт **Swiftgram-MPAK-Mod-unsigned**
4. Подпиши через **ESign** на iPhone

## Файлы мода

```
submodules/TelegramCore/Sources/MPAK/
├── MPAKMessageAttribute.swift   # Атрибут сообщения (isDeleted, editHistory)
├── MPAKDeletedMessages.swift    # Логика анти-удаления
└── MPAKSettings.swift           # Настройки мода

Swiftgram/Sources/MPAK/
└── MPAKSettings.swift           # Настройки и локализация
```

## Настройки

В приложении: Настройки → MPAK
- Переключатель анти-удаления
- Переключатель истории правок
- Информация о разработчике

## Разработчик

**MPAK** • [@naebx](https://t.me/naebx)

---

Основано на [Swiftgram](https://github.com/Swiftgram/Telegram-iOS) и коде [Nicegram 1.5.3](https://github.com/nicegram/Nicegram-iOS).

