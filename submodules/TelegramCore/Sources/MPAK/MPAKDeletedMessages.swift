// MPAK Mod - Anti-Delete Feature
// Based on Nicegram 1.5.3 implementation
// File: submodules/TelegramCore/Sources/MPAK/MPAKDeletedMessages.swift

import Foundation
import Postbox
import SwiftSignalKit

public struct MPAKDeletedMessages {}

// MARK: - Settings
public extension MPAKDeletedMessages {
    private static let antiDeleteKey = "mpak_antiDelete"
    private static let antiEditKey = "mpak_antiEdit"
    
    static var antiDeleteEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: antiDeleteKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: antiDeleteKey) }
    }
    
    static var antiEditEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: antiEditKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: antiEditKey) }
    }
}

// MARK: - Mark Messages as Deleted
public extension MPAKDeletedMessages {
    /// Marks messages as deleted by global IDs (server-side deletion events)
    /// Returns IDs that were NOT marked (should still be deleted)
    static func markMessagesAsDeleted(
        globalIds: [Int32],
        transaction: Transaction
    ) -> [Int32] {
        guard antiDeleteEnabled else {
            return globalIds
        }
        
        var markedIds: [Int32] = []
        let currentTimestamp = Int32(Date().timeIntervalSince1970)
        
        for globalId in globalIds {
            if let id = transaction.messageIdsForGlobalIds([globalId]).first {
                transaction.updateMPAKAttribute(messageId: id) { attr in
                    if !attr.isDeleted {
                        attr.isDeleted = true
                        attr.deletedTimestamp = currentTimestamp
                        markedIds.append(globalId)
                    }
                }
            }
        }
        
        return Array(Set(globalIds).subtracting(markedIds))
    }
    
    /// Marks messages as deleted by MessageId (local deletion requests)
    /// Returns IDs that were NOT marked (should still be deleted)
    static func markMessagesAsDeleted(
        ids: [MessageId],
        transaction: Transaction
    ) -> [MessageId] {
        guard antiDeleteEnabled else {
            return ids
        }
        
        var markedIds: [MessageId] = []
        let currentTimestamp = Int32(Date().timeIntervalSince1970)
        
        for id in ids {
            transaction.updateMPAKAttribute(messageId: id) { attr in
                if !attr.isDeleted {
                    attr.isDeleted = true
                    attr.deletedTimestamp = currentTimestamp
                    markedIds.append(id)
                }
            }
        }
        
        return Array(Set(ids).subtracting(markedIds))
    }
}

// MARK: - Save Edit History
public extension MPAKDeletedMessages {
    /// Saves original message text before edit
    static func saveEditHistory(
        messageId: MessageId,
        originalText: String,
        transaction: Transaction
    ) {
        guard antiEditEnabled, !originalText.isEmpty else { return }
        transaction.addEditHistoryRecord(messageId: messageId, originalText: originalText)
    }
}

// MARK: - Cleanup
public extension MPAKDeletedMessages {
    /// Call when user disables anti-delete to actually delete marked messages
    static func cleanupDeletedMessages(postbox: Postbox) -> Signal<Void, NoError> {
        return postbox.transaction { transaction in
            // Find all messages with isDeleted flag
            // This is a simplified version - actual implementation would iterate through messages
        }
    }
}
