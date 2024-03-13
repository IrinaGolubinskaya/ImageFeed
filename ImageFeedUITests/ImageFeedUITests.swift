//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Irina Golubinskaya on 11.03.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 3))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 3))
        
        loginTextField.tap()
        loginTextField.typeText("")
        webView.tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        passwordTextField.typeText("")
        webView.tap()
        sleep(3)
        
        XCTAssertTrue(webView.buttons["Login"].waitForExistence(timeout: 3))
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        print(app.debugDescription)
    }
    
    func testFeed() throws {
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 0).waitForExistence(timeout: 3))

        let tableQuery = app.tables
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 3))
        
        cell.swipeDown()
        sleep(2)

        let cellTwo = tableQuery.children(matching: .cell).element(boundBy: 1)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 3))
        XCTAssertTrue(cell.buttons["LikeButton"].waitForExistence(timeout: 3))
        
        cellTwo.buttons["LikeButton"].tap()
        sleep(3)
        cellTwo.buttons["LikeButton"].tap()
        sleep(3)

        cellTwo.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        XCTAssertTrue(app.buttons["BackButton"].waitForExistence(timeout: 3))
        
        app.buttons["BackButton"].tap()
    }
    
    func testProfile() throws {
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 1).waitForExistence(timeout: 3))
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.buttons["LogoutButton"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Irina Golubinskaya"].exists)
        XCTAssertTrue(app.staticTexts["@irenegolub111"].exists)

        app.buttons["LogoutButton"].tap()

        XCTAssertTrue(app.alerts["Alert"].waitForExistence(timeout: 3))
        app.alerts["Alert"].buttons["Да"].tap()

        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 3))
    }
}
