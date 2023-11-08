//
//  Profile.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 07.11.2023.
//

import Foundation
struct Profile {
    let username: String
    let name: String // first name +" "+ last name
    let loginName: String // username со знаком @ перед первым символом
    let bio: String

    init(username: String, firstName: String, lastName: String, bio: String) {
        self.username = username
        self.name = "\(firstName) \(lastName)"
        self.loginName = "@\(username)"
        self.bio = bio
    }
}
