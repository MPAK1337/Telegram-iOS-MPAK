// MPAK Mod - Deleted Messages Handler
// File: Swiftgram/Sources/MPAK/MPAKDeletedMessages.swift

import Foundation
import Postbox
import TelegramCore

public final class MPAKDeletedMessages {
    
    // MARK: - Anti-Delete: Mark Messages as Deleted (MessageId based)
    /// Returns array of message IDs that were NOT handled (should be actually deleted)
    public static func markMessagesAsDeleted(ids: [MessageId], transaction: Transaction) -> [MessageId] {
        guard MPAKSettings.antiDeleteEnabled else {
            return ids // Feature disabled, return all IDs for normal deletion
        }
        
        var unhandledIds: [MessageId] = []
        let currentDate = Int32(Date().timeIntervalSince1970)
        
        for id in ids {
            if let message = transaction.getMessage(id) {
                // Mark message as deleted instead of removing
                let _ = transaction.updateMessage(id, update: { currentMessage in
                    var updatedAttributes = currentMessage.attributes
                    
                    // Find or create MPAKMessageAttribute
                    if let existingIndex = updatedAttributes.firstIndex(where: { $0 is MPAKMessageAttribute }) {
                        let existing = updatedAttributes[existingIndex] as! MPAKMessageAttribute
                        updatedAttributes[existingIndex] = existing.withDeletedFlag(date: currentDate)
                    } else {
                        updatedAttributes.append(MPAKMessageAttribute(isDeleted: true, deletedDate: currentDate))
                    }
                    
                    return .update(StoreMessage(
                        id: currentMessage.id,
                        globallyUniqueId: currentMessage.globallyUniqueId,
                        groupingKey: currentMessage.groupingKey,
                        threadId: currentMessage.threadId,
                        timestamp: currentMessage.timestamp,
                        flags: currentMessage.flags,
                        tags: currentMessage.tags,
                        globalTags: currentMessage.globalTags,
                        localTags: currentMessage.localTags,
                        forwardInfo: currentMessage.forwardInfo,
                        authorId: currentMessage.author?.id,
                        text: currentMessage.text,
                        attributes: updatedAttributes,
                        media: currentMessage.media
                    ))
                })
            } else {
                // Message not found, let it be deleted normally
                unhandledIds.append(id)
            }
        }
        
        return unhandledIds
    }
    
    // MARK: - Anti-Delete: Mark Messages as Deleted (Global ID based)
    /// Returns array of global IDs that were NOT handled (should be actually deleted)
    public static func markMessagesAsDeleted(globalIds: [Int32], transaction: Transaction) -> [Int32] {
        guard MPAKSettings.antiDeleteEnabled else {
            return globalIds // Feature disabled, return all IDs for normal deletion
        }
        
        var unhandledIds: [Int32] = []
        let currentDate = Int32(Date().timeIntervalSince1970)
        
        for globalId in globalIds {
            // Try to find message by global ID
            if let messageId = transaction.messageIdForGloballyUniqueMessageId(globalId: Int64(globalId)) {
                if let message = transaction.getMessage(messageId) {
                    let _ = transaction.updateMessage(messageId, update: { currentMessage in
                        var updatedAttributes = currentMessage.attributes
                        
                        // Find or create MPAKMessageAttribute
                        if let existingIndex = updatedAttributes.firstIndex(where: { $0 is MPAKMessageAttribute }) {
                            let existing = updatedAttributes[existingIndex] as! MPAKMessageAttribute
                            updatedAttributes[existingIndex] = existing.withDeletedFlag(date: currentDate)
                        } else {
                            updatedAttributes.append(MPAKMessageAttribute(isDeleted: true, deletedDate: currentDate))
                        }
                        
                        return .update(StoreMessage(
                            id: currentMessage.id,
                            globallyUniqueId: currentMessage.globallyUniqueId,
                            groupingKey: currentMessage.groupingKey,
                            threadId: currentMessage.threadId,
                            timestamp: currentMessage.timestamp,
                            flags: currentMessage.flags,
                            tags: currentMessage.tags,
                            globalTags: currentMessage.globalTags,
                            localTags: currentMessage.localTags,
                            forwardInfo: currentMessage.forwardInfo,
                            authorId: currentMessage.author?.id,
                            text: currentMessage.text,
                            attributes: updatedAttributes,
                            media: currentMessage.media
                        ))
                    })
                } else {
                    unhandledIds.append(globalId)
                }
            } else {
                unhandledIds.append(globalId)
            }
        }
        
        return unhandledIds
    }
    
    // MARK: - Edit History: Save Previous Version
    public static func saveEditHistory(message: Message, updatedAttributes: inout [MessageAttribute]) {
        guard MPAKSettings.antiEditEnabled else {
            return // Feature disabled
        }
        
        // Create history entry from current (previous) message state
        let historyEntry = MPAKEditHistoryEntry(
            text: message.text,
            date: message.timestamp,
            mediaDescription: describeMedia(message.media)
        )
        
        // Find or create MPAKMessageAttribute
        if let existingIndex = updatedAttributes.firstIndex(where: { $0 is MPAKMessageAttribute }) {
            let existing = updatedAttributes[existingIndex] as! MPAKMessageAttribute
            updatedAttributes[existingIndex] = existing.withAddedEditHistory(historyEntry)
        } else {
            updatedAttributes.append(MPAKMessageAttribute(editHistory: [historyEntry]))
        }
    }
    
    // MARK: - Helper: Get Edit History from Message
    public static func getEditHistory(message: Message) -> [MPAKEditHistoryEntry] {
        for attribute in message.attributes {
            if let mpakAttr = attribute as? MPAKMessageAttribute {
                return mpakAttr.editHistory
            }
        }
        return []
    }
    
    // MARK: - Helper: Check if Message is Deleted
    public static func isMessageDeleted(_ message: Message) -> Bool {
        for attribute in message.attributes {
            if let mpakAttr = attribute as? MPAKMessageAttribute {
                return mpakAttr.isDeleted
            }
        }
        return false
    }
    
    // MARK: - Helper: Get Deleted Date
    public static func getDeletedDate(_ message: Message) -> Int32? {
        for attribute in message.attributes {
            if let mpakAttr = attribute as? MPAKMessageAttribute {
                return mpakAttr.deletedDate
            }
        }
        return nil
    }
    
    // MARK: - Private: Describe Media
    private static func describeMedia(_ media: [Media]) -> String? {
        guard !media.isEmpty else { return nil }
        
        var descriptions: [String] = []
        for m in media {
            if m is TelegramMediaImage {
                descriptions.append("[Photo]")
            } else if let file = m as? TelegramMediaFile {
                if file.isVideo {
                    descriptions.append("[Video]")
                } else if file.isVoice {
                    descriptions.append("[Voice]")
                } else if file.isVideoMessage {
                    descriptions.append("[Video Message]")
                } else if file.isSticker {
                    descriptions.append("[Sticker]")
                } else {
                    descriptions.append("[File: \(file.fileName ?? "unknown")]")
                }
            } else if m is TelegramMediaContact {
                descriptions.append("[Contact]")
            } else if m is TelegramMediaMap {
                descriptions.append("[Location]")
            } else if m is TelegramMediaPoll {
                descriptions.append("[Poll]")
            }
        }
        
        return descriptions.isEmpty ? nil : descriptions.joined(separator: ", ")
    }
}
