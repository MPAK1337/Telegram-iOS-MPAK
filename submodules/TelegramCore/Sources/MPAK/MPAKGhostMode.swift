// MPAK Mod - Ghost Mode Settings
// File: submodules/TelegramCore/Sources/MPAK/MPAKGhostMode.swift

import Foundation

public enum MPAKGhostMode {
    private static let hideTypingKey = "mpak_ghost_hideTyping"

    public static var hideTyping: Bool {
        get { UserDefaults.standard.bool(forKey: hideTypingKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: hideTypingKey) }
    }
}
