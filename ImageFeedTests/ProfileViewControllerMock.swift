//
//  ProfileViewControllerMock.swift
//  ImageFeedTests
//
//  Created by Irina Golubinskaya on 12.03.2024.
//

import UIKit
@testable import ImageFeed

final class ProfileViewControllerMock: UIViewController {
    
    var viewDidUpdateAvatar = false
    var viewDidLoadProfile = false
    
    var nameLabel = UILabel()
    var nickNameLabel = UILabel()
    var descriptionLabel = UILabel()
    
    func updateAvatar(url: URL) {
        viewDidUpdateAvatar = true
    }
    
    func loadProfile(_ profile: Profile?) {
        viewDidLoadProfile = true
        if let profile {
            nameLabel.text = profile.name
            nickNameLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
        }
    }
}
