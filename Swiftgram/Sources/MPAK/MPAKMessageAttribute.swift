// MPAK Mod - Custom Message Attribute
// File: Swiftgram/Sources/MPAK/MPAKMessageAttribute.swift

import Foundation
import Postbox

// MARK: - Edit History Entry
public struct MPAKEditHistoryEntry: Codable, Equatable {
    public let text: String
    public let date: Int32
    public let mediaDescription: String?
    
    public init(text: String, date: Int32, mediaDescription: String? = nil) {
        self.text = text
        self.date = date
        self.mediaDescription = mediaDescription
    }
}

// MARK: - MPAK Message Attribute
public final class MPAKMessageAttribute: MessageAttribute, Equatable {
    public let isDeleted: Bool
    public let deletedDate: Int32?
    public let editHistory: [MPAKEditHistoryEntry]
    
    public static func == (lhs: MPAKMessageAttribute, rhs: MPAKMessageAttribute) -> Bool {
        return lhs.isDeleted == rhs.isDeleted &&
               lhs.deletedDate == rhs.deletedDate &&
               lhs.editHistory == rhs.editHistory
    }
    
    public init(isDeleted: Bool = false, deletedDate: Int32? = nil, editHistory: [MPAKEditHistoryEntry] = []) {
        self.isDeleted = isDeleted
        self.deletedDate = deletedDate
        self.editHistory = editHistory
    }
    
    required public init(decoder: PostboxDecoder) {
        self.isDeleted = decoder.decodeBoolForKey("mpak_isDeleted", orElse: false)
        self.deletedDate = decoder.decodeOptionalInt32ForKey("mpak_deletedDate")
        
        if let historyData = decoder.decodeOptionalDataArrayForKey("mpak_editHistory") {
            self.editHistory = historyData.compactMap { data in
                try? JSONDecoder().decode(MPAKEditHistoryEntry.self, from: data)
            }
        } else {
            self.editHistory = []
        }
    }
    
    public func encode(_ encoder: PostboxEncoder) {
        encoder.encodeBool(self.isDeleted, forKey: "mpak_isDeleted")
        if let date = self.deletedDate {
            encoder.encodeInt32(date, forKey: "mpak_deletedDate")
        }
        
        let historyData = self.editHistory.compactMap { entry in
            try? JSONEncoder().encode(entry)
        }
        encoder.encodeDataArray(historyData, forKey: "mpak_editHistory")
    }
    
    // MARK: - Helpers
    public func withAddedEditHistory(_ entry: MPAKEditHistoryEntry) -> MPAKMessageAttribute {
        var newHistory = self.editHistory
        newHistory.append(entry)
        return MPAKMessageAttribute(
            isDeleted: self.isDeleted,
            deletedDate: self.deletedDate,
            editHistory: newHistory
        )
    }
    
    public func withDeletedFlag(date: Int32) -> MPAKMessageAttribute {
        return MPAKMessageAttribute(
            isDeleted: true,
            deletedDate: date,
            editHistory: self.editHistory
        )
    }
    
    public var hasEditHistory: Bool {
        return !self.editHistory.isEmpty
    }
}
