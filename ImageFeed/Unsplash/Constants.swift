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
