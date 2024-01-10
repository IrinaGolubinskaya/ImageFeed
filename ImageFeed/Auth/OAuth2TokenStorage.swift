//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 05.10.2023.
//

import SwiftKeychainWrapper

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
}
