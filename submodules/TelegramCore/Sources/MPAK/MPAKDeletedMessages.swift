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
    private static let savePrivateChatsKey = "mpak_savePrivateChats"
    private static let saveGroupChatsKey = "mpak_saveGroupChats"
    private static let saveChannelsKey = "mpak_saveChannels"
    private static let saveBotsKey = "mpak_saveBots"
    private static let deletedMessageIdsKey = "mpak_deletedMessageIds"
    
    static var antiDeleteEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: antiDeleteKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: antiDeleteKey) }
    }
    
    static var antiEditEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: antiEditKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: antiEditKey) }
    }

    static var savePrivateChats: Bool {
        get {
            if UserDefaults.standard.object(forKey: savePrivateChatsKey) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: savePrivateChatsKey)
        }
        set { UserDefaults.standard.setValue(newValue, forKey: savePrivateChatsKey) }
    }

    static var saveGroupChats: Bool {
        get {
            if UserDefaults.standard.object(forKey: saveGroupChatsKey) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: saveGroupChatsKey)
        }
        set { UserDefaults.standard.setValue(newValue, forKey: saveGroupChatsKey) }
    }

    static var saveChannels: Bool {
        get {
            if UserDefaults.standard.object(forKey: saveChannelsKey) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: saveChannelsKey)
        }
        set { UserDefaults.standard.setValue(newValue, forKey: saveChannelsKey) }
    }

    static var saveBots: Bool {
        get {
            if UserDefaults.standard.object(forKey: saveBotsKey) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: saveBotsKey)
        }
        set { UserDefaults.standard.setValue(newValue, forKey: saveBotsKey) }
    }

    private static func loadDeletedMessageIdStrings() -> Set<String> {
        let stored = UserDefaults.standard.array(forKey: deletedMessageIdsKey) as? [String] ?? []
        return Set(stored)
    }

    private static func persistDeletedMessageIdStrings(_ ids: Set<String>) {
        UserDefaults.standard.setValue(Array(ids), forKey: deletedMessageIdsKey)
    }

    private static func deletedMessageIdString(_ id: MessageId) -> String {
        return "\(id.peerId.toInt64()):\(id.namespace):\(id.id)"
    }

    private static func messageId(from string: String) -> MessageId? {
        let parts = string.split(separator: ":")
        guard parts.count == 3,
              let peerIdValue = Int64(parts[0]),
              let namespace = Int32(parts[1]),
              let idValue = Int32(parts[2]) else {
            return nil
        }
        return MessageId(peerId: PeerId(peerIdValue), namespace: namespace, id: idValue)
    }
}

// MARK: - Mark Messages as Deleted
public extension MPAKDeletedMessages {
    private static func shouldSaveForPeer(_ peerId: PeerId) -> Bool {
        switch peerId.namespace {
        case Namespaces.Peer.CloudUser:
            return savePrivateChats
        case Namespaces.Peer.CloudGroup:
            return saveGroupChats
        case Namespaces.Peer.CloudChannel:
            return saveChannels
        case Namespaces.Peer.SecretChat:
            return savePrivateChats
        default:
            return true
        }
    }

    private static func isPeerBot(_ peer: Peer?) -> Bool {
        if let user = peer as? TelegramUser {
            return user.botInfo != nil
        }
        return false
    }

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
        
        var storedIds = loadDeletedMessageIdStrings()
        for globalId in globalIds {
            guard let id = transaction.messageIdsForGlobalIds([globalId]).first else {
                continue
            }

            guard shouldSaveForPeer(id.peerId) else {
                continue
            }

            if let message = transaction.getMessage(id),
               isPeerBot(message.author),
               !saveBots {
                continue
            }

            transaction.updateMPAKAttribute(messageId: id) { attr in
                if !attr.isDeleted {
                    attr.isDeleted = true
                    attr.deletedTimestamp = currentTimestamp
                    markedIds.append(globalId)
                }
            }
            storedIds.insert(deletedMessageIdString(id))
        }
        persistDeletedMessageIdStrings(storedIds)
        
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
        
        var storedIds = loadDeletedMessageIdStrings()
        for id in ids {
            guard shouldSaveForPeer(id.peerId) else {
                continue
            }

            if let message = transaction.getMessage(id),
               isPeerBot(message.author),
               !saveBots {
                continue
            }

            transaction.updateMPAKAttribute(messageId: id) { attr in
                if !attr.isDeleted {
                    attr.isDeleted = true
                    attr.deletedTimestamp = currentTimestamp
                    markedIds.append(id)
                }
            }
            storedIds.insert(deletedMessageIdString(id))
        }
        persistDeletedMessageIdStrings(storedIds)
        
        return Array(Set(ids).subtracting(markedIds))
    }
}

// MARK: - Save Edit History
public extension MPAKDeletedMessages {
    /// Saves original message text before edit - works inside updateMessage closure
    static func saveEditHistory(
        previousMessage: Message,
        updatedText: String,
        updatedAttributes: inout [MessageAttribute]
    ) {
        guard antiEditEnabled else { return }

        guard shouldSaveForPeer(previousMessage.id.peerId) else { return }

        if isPeerBot(previousMessage.author), !saveBots {
            return
        }
        
        let originalText = previousMessage.text
        let finalText = updatedText
        guard !originalText.isEmpty || !finalText.isEmpty else { return }
        
        // Get or create MPAK attribute from existing updated attributes
        var mpakAttr: MPAKMessageAttribute
        if let existing = updatedAttributes.first(where: { $0 is MPAKMessageAttribute }) as? MPAKMessageAttribute {
            mpakAttr = MPAKMessageAttribute(
                isDeleted: existing.isDeleted,
                deletedTimestamp: existing.deletedTimestamp,
                editHistory: existing.editHistory
            )
        } else if let existing = previousMessage.mpakAttribute {
            mpakAttr = MPAKMessageAttribute(
                isDeleted: existing.isDeleted,
                deletedTimestamp: existing.deletedTimestamp,
                editHistory: existing.editHistory
            )
        } else {
            mpakAttr = MPAKMessageAttribute()
        }
        
        // Add edit record with original text
        let record = MPAKEditRecord(
            originalText: originalText,
            finalText: finalText,
            timestamp: previousMessage.timestamp
        )
        mpakAttr.editHistory.append(record)
        
        // Update attributes array
        updatedAttributes.removeAll { $0 is MPAKMessageAttribute }
        updatedAttributes.append(mpakAttr)
    }
}

// MARK: - Cleanup
public extension MPAKDeletedMessages {
    /// Call when user disables anti-delete to actually delete marked messages
    static func cleanupDeletedMessages(postbox: Postbox) -> Signal<Void, NoError> {
        return postbox.transaction { transaction in
            let storedIds = loadDeletedMessageIdStrings()
            guard !storedIds.isEmpty else {
                return
            }

            for stringId in storedIds {
                guard let messageId = messageId(from: stringId),
                      transaction.getMessage(messageId) != nil else {
                    continue
                }
                transaction.updateMPAKAttribute(messageId: messageId) { attr in
                    attr.isDeleted = false
                    attr.deletedTimestamp = nil
                }
            }

            persistDeletedMessageIdStrings([])
        }
    }
}
