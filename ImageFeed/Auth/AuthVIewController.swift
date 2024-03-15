//
//  AuthVIewController.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 17.09.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(
        _ vc: AuthViewController,
        didAuthenticateWithCode code: String
    )
}

final class AuthViewController: UIViewController {
    @IBOutlet private weak var authButton: UIButton!
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authButton.accessibilityIdentifier = "Authenticate"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

// MARK: - SplashAlertDelegate

extension AuthViewController: SplashAlertDelegate {
    func showErrorAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
}
