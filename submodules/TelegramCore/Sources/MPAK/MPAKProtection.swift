// MPAK Mod - Protection & Restrictions Settings
// File: submodules/TelegramCore/Sources/MPAK/MPAKProtection.swift

import Foundation

public enum MPAKProtection {
    private static let disableScreenshotNotificationsKey = "mpak_disableScreenshotNotifications"
    private static let disableScreenCaptureAlertsKey = "mpak_disableScreenCaptureAlerts"
    private static let allowProtectedContentSaveKey = "mpak_allowProtectedContentSave"
    private static let allowSelfDestructSaveKey = "mpak_allowSelfDestructSave"

    public static var disableScreenshotNotifications: Bool {
        get { UserDefaults.standard.bool(forKey: disableScreenshotNotificationsKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: disableScreenshotNotificationsKey) }
    }

    public static var disableScreenCaptureAlerts: Bool {
        get { UserDefaults.standard.bool(forKey: disableScreenCaptureAlertsKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: disableScreenCaptureAlertsKey) }
    }

    public static var allowProtectedContentSave: Bool {
        get { UserDefaults.standard.bool(forKey: allowProtectedContentSaveKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: allowProtectedContentSaveKey) }
    }

    public static var allowSelfDestructSave: Bool {
        get { UserDefaults.standard.bool(forKey: allowSelfDestructSaveKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: allowSelfDestructSaveKey) }
    }
}
