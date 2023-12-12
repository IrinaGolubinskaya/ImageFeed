//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 12.10.2023.
//

import UIKit
import ProgressHUD
import SwiftKeychainWrapper 

final class SplashViewController: UIViewController {
    
    private let splashScreenLogoImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "logoForUnsplash")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oauth2Service.isAuthorized {
            UIBlockingProgressHUD.show()
            if let token = oauth2TokenStorage.token {
                fetchProfile(token: token)
            }
        } else {
            showAuthVC()
        }
    }
    
    private func setupViewsVC() {
        view.backgroundColor = .ypBlack
        view.addSubview(splashScreenLogoImage)
        NSLayoutConstraint.activate([
            splashScreenLogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashScreenLogoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashScreenLogoImage.widthAnchor.constraint(equalToConstant: 75),
            splashScreenLogoImage.heightAnchor.constraint(equalToConstant: 77.68),
        ])
    }
    
    private func showAuthVC() {
        let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "AuthViewController")
        guard let authViewController = viewController as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated:  true)
    }
}

// MARK: - prepare for segue

extension SplashViewController {
    
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { return }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
}

// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchToken(code)
        }
    }
    
    private func fetchToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.getAlert()
                break
            }
        }
    }
    
    private func fetchProfile(token:String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                guard let userName = self.profileService.profile?.username else { return }
                self.profileImageService.fetchProfileImageURL(username: userName) { _ in }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.getAlert()
            }
        }
    }
    
    private func getAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "Ок", style: .cancel)
        alert.addAction(actionAlert)
        present(alert,animated: true)
    }
}
