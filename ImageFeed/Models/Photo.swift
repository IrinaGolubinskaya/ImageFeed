//
//  Photo.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 10.01.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    mutating func changeLike() {
        isLiked = isLiked ? false : true
    }
}
