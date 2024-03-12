//
//  ImageFeedTests.swift
//  WebViewTests
//
//  Created by Irina Golubinskaya on 12.03.2024.
//

import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {
    
    func testPresenterCallsLoadRequest() {
        // given
        let viewController = WebViewViewControllerMock()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressHiddenWhenOne() {
        // given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testCodeFromURL() {
        //given
        
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        let authHelper = AuthHelper()
        
        //when
        
        let code = authHelper.code(from: url)
        
        //then
        
        XCTAssertEqual(code, "test code")
    }
}
