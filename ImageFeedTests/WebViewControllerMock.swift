//
//  WebViewControllerMock.swift
//  ImageFeedTests
//
//  Created by Irina Golubinskaya on 12.03.2024.
//

import ImageFeed
import Foundation

final class WebViewViewControllerMock: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?

    var loadRequestCalled: Bool = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {

    }
}
