// MPAK Mod - Settings
// File: Swiftgram/Sources/MPAK/MPAKSettings.swift

import Foundation
import UIKit

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
    
    // MARK: - Deleted Message Gradient Colors
    public struct DeletedMessageGradient {
        // Pink-Purple gradient for deleted messages
        public static let startColor = UIColor(red: 1.0, green: 0.42, blue: 0.62, alpha: 0.3) // #FF6B9D with 30% opacity
        public static let endColor = UIColor(red: 0.77, green: 0.29, blue: 1.0, alpha: 0.3)   // #C44AFF with 30% opacity
        
        // Gradient colors as hex for reference
        public static let startColorHex: UInt32 = 0xFF6B9D
        public static let endColorHex: UInt32 = 0xC44AFF
        
        /// Returns a CAGradientLayer configured for deleted message highlight
        public static func makeGradientLayer(frame: CGRect) -> CAGradientLayer {
            let gradient = CAGradientLayer()
            gradient.frame = frame
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
            gradient.cornerRadius = 8
            return gradient
        }
    }
    
    // MARK: - Localization
    public struct Strings {
        public static let sectionTitle = "MPAK"
        
        public static let antiDeleteTitle = "Anti-Delete"
        public static let antiDeleteDescription = "Keep deleted messages visible with special highlight"
        
        public static let antiEditTitle = "Edit History"
        public static let antiEditDescription = "Save message versions before edits"
        
        public static let historyButtonTitle = "History"
        public static let deletedIndicator = "[deleted]"
        
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
        public static let deletedIndicatorRu = "[удалено]"
        
        public static let aboutTitleRu = "О разработчике"
        public static let aboutDeveloperRu = "Разработано MPAK"
        public static let contactTelegramRu = "Написать в Telegram"
    }
}
