//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 06.12.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        
        self.viewControllers = [ imageListViewController, profileViewController]
    }
}
