//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 25.08.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet weak private var profileImageView: UIImageView!
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var nicknameLabel: UILabel!
    @IBOutlet weak private var userStatusLabel: UILabel!
    @IBOutlet weak private var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
