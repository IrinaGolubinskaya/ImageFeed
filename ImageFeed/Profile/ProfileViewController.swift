//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 25.08.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage()
    private let nameLabel = UILabel()
    private let profileImage = UIImageView()
    private let nickNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logoutButton = UIButton()
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            })
        view.backgroundColor = .ypBlack
        addProfilePhoto()
        addProfileName()
        addNickName()
        addStatusLabel()
        updateAvatar()
        addLogoutButton()
        updateProfileDetails(profile: profileService.profile)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
    }
    
    deinit {
        NotificationCenter.default.removeObserver(profileImageServiceObserver)
    }
    
    private func updateAvatar() {
        guard let url = ProfileImageService.shared.avatarURL else {
            print("аватар нил")
            return
        }
        profileImage.kf.setImage(with: url)
    }
    
    private func updateProfileDetails(profile: Profile?) {
        nameLabel.text = profile?.name
        nickNameLabel.text = profile?.loginName
        descriptionLabel.text = profile?.bio
    }
    
    private func addProfilePhoto() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
        profileImage.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ]
        )
    }
    
    private func addProfileName() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font.withSize(20)
        nameLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor , constant: 8),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func addNickName() {
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickNameLabel)
        nickNameLabel.text = "@ekaterina_nov"
        nickNameLabel.textColor = .ypGrey
        nickNameLabel.font.withSize(13)
        nickNameLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            nickNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nickNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nickNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func addStatusLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font.withSize(13)
        descriptionLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func addLogoutButton() {
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.setImage(UIImage(named: "logout"), for: .normal)
        logoutButton.addTarget(nil, action: #selector(showLogoutAlert), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor)
        ])
    }
    
    @objc private func showLogoutAlert() {
        let alert = UIAlertController(title: "Пока, пока!",
                                      message: "Уверены что хотите выйти?",
                                      preferredStyle: .alert)
        let closeAlertAction = UIAlertAction(title: "Нет", style: .cancel)
        let logoutAlertAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.tokenStorage.deleteToken()
            CleanService.clean()
            
            guard let window = UIApplication.shared.windows.first else { return }
            window.rootViewController = SplashViewController()
        }
        
        alert.addAction(closeAlertAction)
        alert.addAction(logoutAlertAction)
        present(alert, animated:  true)
    }
}
