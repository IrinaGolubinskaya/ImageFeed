//
//  Profile.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 07.11.2023.
//

import Foundation

struct Profile: Codable {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(username: String, firstName: String, lastName: String, bio: String?) {
        self.username = username
        self.name = "\(firstName) \(lastName)"
        self.loginName = "@\(username)"
        self.bio = bio
    }
}
