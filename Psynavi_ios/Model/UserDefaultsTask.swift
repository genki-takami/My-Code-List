/*
 UserDefaultsの処理
 */

import Foundation

final class UserDefaultsTask {
    
    /// - Parameters:
    ///   - key:        A key in the current user‘s defaults database.
    /// - Returns:      Returns the string associated with the specified key.
    static func getUserData(_ key: String) -> String? {
       return UserDefaults.standard.string(forKey: key)
    }
    
    /// - Parameters:
    ///   - value:      The value for the property identified by key.
    ///   - key:        The name of one of the receiver's properties.
    static func setUserData(_ value: String, _ key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    /// - Parameters:
    ///   - key:        A key in the current user‘s defaults database.
    /// - Returns:      Returns the Boolean value associated with the specified key.
    static func getPersonalData(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    /// - Parameters:
    ///   - value:      The value for the property identified by key.
    ///   - key:        The name of one of the receiver's properties.
    static func setPersonalData(_ value: Bool, _ key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    /// - Parameters:
    ///   - key:        A key in the current user‘s defaults database.
    /// - Returns:      Returns the array of strings associated with the specified key.
    static func getAccountData(_ key: String) -> [String]? {
        return UserDefaults.standard.stringArray(forKey: key)
    }
    
    /// - Parameters:
    ///   - value:      The value for the property identified by key.
    ///   - key:        The name of one of the receiver's properties.
    static func setAccountData(_ value: [String], _ key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
}
