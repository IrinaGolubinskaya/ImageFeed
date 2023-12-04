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
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let token = oauth2TokenStorage.token {
            fetchProfile(token: token)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //let removeSuccessful: Bool = KeychainWrapper.standard.removeAllKeys()
//        if let _ = oauth2TokenStorage.token {
//            switchToTabBarController()
//        } else {
//            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
//        }
    }
}

// MARK: - prepare for segue

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                return
            }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
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
