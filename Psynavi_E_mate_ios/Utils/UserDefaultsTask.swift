/*
 端末アプリ固有のデータ保存
 */

import Foundation

final class UserDefaultsTask {
    
    static let us = UserDefaults.standard
    
    /// - Parameters:
    ///   - key:        A key in the current user‘s defaults database.
    /// - Returns:      Returns the Boolean value associated with the specified key.
    static func checkPurchased(_ key: String) -> Bool {
        return us.bool(forKey: key)
    }
    
    /// - Parameters:
    ///   - value:      The value for the property identified by key.
    ///   - key:        The name of one of the receiver's properties.
    static func setPurchaseRecord(_ value: Bool, _ key: String) {
        us.setValue(value, forKey: key)
    }
}
