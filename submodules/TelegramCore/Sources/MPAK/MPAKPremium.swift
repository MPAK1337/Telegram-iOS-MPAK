// MPAK Mod - Local Premium Settings
// File: submodules/TelegramCore/Sources/MPAK/MPAKPremium.swift

import Foundation

public enum MPAKPremium {
    private static let forcePremiumKey = "mpak_forcePremium"

    public static var forcePremium: Bool {
        get { UserDefaults.standard.bool(forKey: forcePremiumKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: forcePremiumKey) }
    }
}
