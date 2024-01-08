//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 05.10.2023.
//

import SwiftKeychainWrapper
import WebKit

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case token
    }
    
    var token: String? { 
        get {
            KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
        } set {
            guard let newValue = newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: Keys.token.rawValue)
            guard isSuccess else { return }
        }
    }
    
    func deleteToken() {
        token = nil
        KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
    }
    
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
