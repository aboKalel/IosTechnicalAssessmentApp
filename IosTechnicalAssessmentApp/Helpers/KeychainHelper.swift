//
//  KeychainHelper.swift
//  IosTechnicalAssessmentApp
//
//  Created by Ibrahim on 09/08/1445 AH.
//

import Foundation
class KeychainHelper {
    static func storeUserLoginInfo(username: String, password: String) {
        let userLoginInfo: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: password.data(using: .utf8)!,
        ]
        
        SecItemAdd(userLoginInfo as CFDictionary, nil)
    }
    
    static func retrieveUserLoginInfo(username: String)  {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: username,
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true,
    ]
    var item: CFTypeRef?
    // Check if user exists in the keychain
    if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
        // Extract result
        if let existingItem = item as? [String: Any],
           let username = existingItem[kSecAttrAccount as String] as? String,
           let passwordData = existingItem[kSecValueData as String] as? Data,
           let password = String(data: passwordData, encoding: .utf8)
        {
            print(username)
            print(password)
        }
    } else {
        print("Something went wrong trying to find the user in the keychain")
    }
    
    }
}
