// MPAK Mod - Settings
// File: Swiftgram/Sources/MPAK/MPAKSettings.swift

import Foundation

public struct MPAKSettings {
    
    // MARK: - Keys
    private static let antiDeleteKey = "mpak_antiDelete"
    private static let antiEditKey = "mpak_antiEdit"
    
    // MARK: - Anti-Delete
    public static var antiDeleteEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: antiDeleteKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: antiDeleteKey) }
    }
    
    // MARK: - Anti-Edit (History)
    public static var antiEditEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: antiEditKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: antiEditKey) }
    }
    
    // MARK: - Developer Info
    public static let developerName = "MPAK"
    public static let developerTelegram = "https://t.me/naebx"
    public static let modVersion = "1.0.0"
    
    // MARK: - Localization
    public struct Strings {
        public static let sectionTitle = "MPAK"
        
        public static let antiDeleteTitle = "Anti-Delete"
        public static let antiDeleteDescription = "Keep deleted messages visible with special highlight"
        
        public static let antiEditTitle = "Edit History"
        public static let antiEditDescription = "Save message versions before edits"
        
        public static let historyButtonTitle = "History"
        
        public static let aboutTitle = "About Developer"
        public static let aboutDeveloper = "Developed by MPAK"
        public static let contactTelegram = "Contact on Telegram"
        
        // Russian
        public static let sectionTitleRu = "MPAK"
        
        public static let antiDeleteTitleRu = "Анти-удаление"
        public static let antiDeleteDescriptionRu = "Сохранять удалённые сообщения с подсветкой"
        
        public static let antiEditTitleRu = "История правок"
        public static let antiEditDescriptionRu = "Сохранять версии сообщений до редактирования"
        
        public static let historyButtonTitleRu = "История"
        
        public static let aboutTitleRu = "О разработчике"
        public static let aboutDeveloperRu = "Разработано MPAK"
        public static let contactTelegramRu = "Написать в Telegram"
    }
}
