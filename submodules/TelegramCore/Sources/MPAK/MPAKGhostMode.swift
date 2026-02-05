// MPAK Mod - Ghost Mode Settings
// File: submodules/TelegramCore/Sources/MPAK/MPAKGhostMode.swift

import Foundation

public enum MPAKGhostMode {
    private static let hideTypingKey = "mpak_ghost_hideTyping"
    private static let hideOnlineStatusKey = "mpak_ghost_hideOnlineStatus"
    private static let hideReadReceiptsKey = "mpak_ghost_hideReadReceipts"
    private static let hideStoryViewsKey = "mpak_ghost_hideStoryViews"
    private static let hideAudioRecordingKey = "mpak_ghost_hideAudioRecording"
    private static let hideVideoMessagesKey = "mpak_ghost_hideVideoMessages"
    private static let hideUploadsKey = "mpak_ghost_hideUploads"
    private static let hideStickerInteractionsKey = "mpak_ghost_hideStickerInteractions"
    private static let hideGroupCallVoiceKey = "mpak_ghost_hideGroupCallVoice"
    private static let hideGameActivityKey = "mpak_ghost_hideGameActivity"
    private static let hideEmojiReactionsKey = "mpak_ghost_hideEmojiReactions"
    private static let hideLocationSharingKey = "mpak_ghost_hideLocationSharing"
    private static let hideContactSharingKey = "mpak_ghost_hideContactSharing"

    public static var hideTyping: Bool {
        get { UserDefaults.standard.bool(forKey: hideTypingKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: hideTypingKey) }
    }

    public static var hideOnlineStatus: Bool {
        get { UserDefaults.standard.bool(forKey: hideOnlineStatusKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: hideOnlineStatusKey) }
    }

    public static var hideReadReceipts: Bool {
        get { UserDefaults.standard.bool(forKey: hideReadReceiptsKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: hideReadReceiptsKey) }
    }

    public static var hideStoryViews: Bool {
        get { UserDefaults.standard.bool(forKey: hideStoryViewsKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: hideStoryViewsKey) }
    }

    public static var hideAudioRecording: Bool {
        get { UserDefaults.standard.bool(forKey: hideAudioRecordingKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: hideAudioRecordingKey) }
    }

    public static var hideVideoMessages: Bool {
        get { UserDefaults.standard.bool(forKey: hideVideoMessagesKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: hideVideoMessagesKey) }
    }

    public static var hideUploads: Bool {
        get { UserDefaults.standard.bool(forKey: hideUploadsKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: hideUploadsKey) }
    }

    public static var hideStickerInteractions: Bool {
        get { UserDefaults.standard.bool(forKey: hideStickerInteractionsKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: hideStickerInteractionsKey) }
    }

    public static var hideGroupCallVoice: Bool {
        get { UserDefaults.standard.bool(forKey: hideGroupCallVoiceKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: hideGroupCallVoiceKey) }
    }

    public static var hideGameActivity: Bool {
        get { UserDefaults.standard.bool(forKey: hideGameActivityKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: hideGameActivityKey) }
    }

    public static var hideEmojiReactions: Bool {
        get { UserDefaults.standard.bool(forKey: hideEmojiReactionsKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: hideEmojiReactionsKey) }
    }

    public static var hideLocationSharing: Bool {
        get { UserDefaults.standard.bool(forKey: hideLocationSharingKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: hideLocationSharingKey) }
    }

    public static var hideContactSharing: Bool {
        get { UserDefaults.standard.bool(forKey: hideContactSharingKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: hideContactSharingKey) }
    }
}
