// MPAK Mod - Settings
// File: Swiftgram/Sources/MPAK/MPAKSettings.swift

import Foundation
import UIKit

public struct MPAKSettings {
    
    // MARK: - Keys
    private static let antiDeleteKey = "mpak_antiDelete"
    private static let antiEditKey = "mpak_antiEdit"
    
    // Chat type filter keys
    private static let savePrivateChatsKey = "mpak_savePrivateChats"
    private static let saveGroupChatsKey = "mpak_saveGroupChats"
    private static let saveChannelsKey = "mpak_saveChannels"
    private static let saveBotsKey = "mpak_saveBots"
    
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
    
    // MARK: - Chat Type Filters (default: all enabled)
    public static var savePrivateChats: Bool {
        get { 
            if UserDefaults.standard.object(forKey: savePrivateChatsKey) == nil {
                return true // default enabled
            }
            return UserDefaults.standard.bool(forKey: savePrivateChatsKey) 
        }
        set { UserDefaults.standard.setValue(newValue, forKey: savePrivateChatsKey) }
    }
    
    public static var saveGroupChats: Bool {
        get { 
            if UserDefaults.standard.object(forKey: saveGroupChatsKey) == nil {
                return true // default enabled
            }
            return UserDefaults.standard.bool(forKey: saveGroupChatsKey) 
        }
        set { UserDefaults.standard.setValue(newValue, forKey: saveGroupChatsKey) }
    }
    
    public static var saveChannels: Bool {
        get { 
            if UserDefaults.standard.object(forKey: saveChannelsKey) == nil {
                return true // default enabled
            }
            return UserDefaults.standard.bool(forKey: saveChannelsKey) 
        }
        set { UserDefaults.standard.setValue(newValue, forKey: saveChannelsKey) }
    }
    
    public static var saveBots: Bool {
        get { 
            if UserDefaults.standard.object(forKey: saveBotsKey) == nil {
                return true // default enabled
            }
            return UserDefaults.standard.bool(forKey: saveBotsKey) 
        }
        set { UserDefaults.standard.setValue(newValue, forKey: saveBotsKey) }
    }
    
    // MARK: - Developer Info
    public static let developerName = "MPAK"
    public static let developerTelegram = "https://t.me/naebx"
    public static let modVersion = "1.0.0"
    
    // MARK: - Deleted Message UI
    public struct DeletedMessageUI {
        // Opacity for deleted messages (lower = more transparent)
        public static let opacity: CGFloat = 0.6
        
        // Trash icon name from SF Symbols
        public static let trashIconName = "trash.fill"
    }
}
