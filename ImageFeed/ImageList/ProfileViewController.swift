//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 25.08.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    let nameLabel = UILabel()
    let profileImage = UIImageView()
    let nickNameLabel = UILabel()
    let statusLabel = UILabel()
    let logoutButton = UIButton()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfilePhoto()
        getProfileName()
        getNickName()
        getStatusLabel()
        getLogoutButton()
    }
    
    func getProfilePhoto() {
        let image = UIImage(named: "userPhoto")
        profileImage.image = image
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ]
        )
    }
    
    func getProfileName() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font.withSize(20)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor , constant: 8),
        ])
    }
    
    func getNickName() {
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickNameLabel)
        nickNameLabel.text = "@ekaterina_nov"
        nickNameLabel.textColor = .ypGrey
        nickNameLabel.font.withSize(13)
        
        NSLayoutConstraint.activate([
            nickNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nickNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
        ])
    }
    
    func getStatusLabel() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        statusLabel.text = "Hello, world!"
        statusLabel.textColor = .ypWhite
        statusLabel.font.withSize(13)
        
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8)
        ])
    }
    
    func getLogoutButton() {
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.setImage(UIImage(named: "logout"), for: .normal)
        
        NSLayoutConstraint.activate([
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor)
        ])
    }
}
