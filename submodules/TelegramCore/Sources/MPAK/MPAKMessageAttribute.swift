// MPAK Mod - Anti-Delete & Edit History Feature
// Based on Nicegram 1.5.3 implementation
// File: submodules/TelegramCore/Sources/MPAK/MPAKMessageAttribute.swift

import Foundation
import Postbox

public class MPAKMessageAttribute: MessageAttribute {
    public var isDeleted: Bool
    public var deletedTimestamp: Int32?
    public var editHistory: [MPAKEditRecord]
    
    public init(
        isDeleted: Bool = false,
        deletedTimestamp: Int32? = nil,
        editHistory: [MPAKEditRecord] = []
    ) {
        self.isDeleted = isDeleted
        self.deletedTimestamp = deletedTimestamp
        self.editHistory = editHistory
    }
    
    public required init(decoder: PostboxDecoder) {
        self.isDeleted = decoder.decodeBoolForKey("mpak_isDeleted", orElse: false)
        self.deletedTimestamp = decoder.decodeOptionalInt32ForKey("mpak_deletedTimestamp")
        
        let historyCount = decoder.decodeInt32ForKey("mpak_editHistoryCount", orElse: 0)
        var history: [MPAKEditRecord] = []
        for i in 0..<historyCount {
            let originalText = decoder.decodeStringForKey("mpak_editOriginalText_\(i)", orElse: "")
            let finalText = decoder.decodeStringForKey("mpak_editFinalText_\(i)", orElse: "")
            let fallbackText = decoder.decodeStringForKey("mpak_editText_\(i)", orElse: "")
            let timestamp = decoder.decodeInt32ForKey("mpak_editTime_\(i)", orElse: 0)
            let resolvedOriginal = originalText.isEmpty ? fallbackText : originalText
            let resolvedFinal = finalText.isEmpty ? fallbackText : finalText
            history.append(MPAKEditRecord(originalText: resolvedOriginal, finalText: resolvedFinal, timestamp: timestamp))
        }
        self.editHistory = history
    }
    
    public func encode(_ encoder: PostboxEncoder) {
        encoder.encodeBool(isDeleted, forKey: "mpak_isDeleted")
        if let deletedTimestamp {
            encoder.encodeInt32(deletedTimestamp, forKey: "mpak_deletedTimestamp")
        }
        
        encoder.encodeInt32(Int32(editHistory.count), forKey: "mpak_editHistoryCount")
        for (i, record) in editHistory.enumerated() {
            encoder.encodeString(record.originalText, forKey: "mpak_editOriginalText_\(i)")
            encoder.encodeString(record.finalText, forKey: "mpak_editFinalText_\(i)")
            encoder.encodeInt32(record.timestamp, forKey: "mpak_editTime_\(i)")
        }
    }
}

// MARK: - Edit Record
public struct MPAKEditRecord: Equatable {
    public let originalText: String
    public let finalText: String
    public let timestamp: Int32
    
    public init(originalText: String, finalText: String, timestamp: Int32) {
        self.originalText = originalText
        self.finalText = finalText
        self.timestamp = timestamp
    }
    
    public var formattedDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Message Extension
public extension Message {
    var mpakAttribute: MPAKMessageAttribute? {
        for attribute in self.attributes {
            if let mpakAttribute = attribute as? MPAKMessageAttribute {
                return mpakAttribute
            }
        }
        return nil
    }
    
    var isDeletedByMPAK: Bool {
        return mpakAttribute?.isDeleted ?? false
    }
    
    var hasEditHistory: Bool {
        guard let attr = mpakAttribute else { return false }
        return !attr.editHistory.isEmpty
    }
    
    var editHistoryCount: Int {
        return mpakAttribute?.editHistory.count ?? 0
    }
}

// MARK: - Transaction Extension
public extension Transaction {
    func updateMPAKAttribute(messageId: MessageId, _ block: (inout MPAKMessageAttribute) -> Void) {
        self.updateMessage(messageId) { message in
            var attributes = message.attributes
            var mpakAttr = (attributes.first { $0 is MPAKMessageAttribute } as? MPAKMessageAttribute) ?? MPAKMessageAttribute()
            
            block(&mpakAttr)
            
            attributes.removeAll { $0 is MPAKMessageAttribute }
            attributes.append(mpakAttr)
            
            return .update(StoreMessage(
                id: message.id,
                customStableId: message.stableId,
                globallyUniqueId: message.globallyUniqueId,
                groupingKey: message.groupingKey,
                threadId: message.threadId,
                timestamp: message.timestamp,
                flags: StoreMessageFlags(message.flags),
                tags: message.tags,
                globalTags: message.globalTags,
                localTags: message.localTags,
                forwardInfo: message.forwardInfo.map(StoreMessageForwardInfo.init),
                authorId: message.author?.id,
                text: message.text,
                attributes: attributes,
                media: message.media
            ))
        }
    }
    
    func addEditHistoryRecord(messageId: MessageId, originalText: String) {
        updateMPAKAttribute(messageId: messageId) { attr in
            let record = MPAKEditRecord(
                originalText: originalText,
                finalText: originalText,
                timestamp: Int32(Date().timeIntervalSince1970)
            )
            attr.editHistory.append(record)
        }
    }
}
