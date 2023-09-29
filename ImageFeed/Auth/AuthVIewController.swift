//
//  AuthVIewController.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 17.09.2023.
//

import UIKit

final class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //TODO: process code
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    
    let ShowWebViewSegueIdentifier = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWebView" {
            let viewController = segue.destination as! WebViewViewController
            viewController.delegate = self
            
        }
    }
}
