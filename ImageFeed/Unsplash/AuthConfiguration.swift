//
//  Constants.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 13.09.2023.
//

import Foundation

enum Constants {
    static let accessKey = "rccp9jtEDxusbT0gckY2LdWpP-wnaJzHMQ_EgGC2ZEw"
    static let secretKey = "7McL54RlLRV6UWCoBmsf7M7Zy6F7LJdlGw0URadEWt0"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!

    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashBaseURLString = "https://unsplash.com"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
