//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 05.10.2023.
//

import Foundation

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.token.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
