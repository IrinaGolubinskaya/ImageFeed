//
//  ProfileViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Irina Golubinskaya on 12.03.2024.
//

import Foundation
@testable import ImageFeed
import XCTest

final class ProfileViewControllerTests: XCTestCase {
    let viewController = ProfileViewControllerMock()
    
    func testPresenterCallsLoadProfile() {
        // given
        let testString = "Irene"
        
        let profile = Profile(username: testString, firstName: testString, lastName: testString, bio: testString)
        
        // when
        viewController.loadProfile(profile)
        
        // then
        XCTAssertTrue(viewController.viewDidLoadProfile)
        XCTAssertEqual(viewController.descriptionLabel.text, testString)
        XCTAssertEqual(viewController.nameLabel.text, "\(testString) \(testString)")
        XCTAssertEqual(viewController.nickNameLabel.text, "@\(testString)")
    }
    
    func testCallsUpdateAvatar() {
      // given
      let testUrl = URL(string: "https://practicum.yandex.ru")!

      // when
      viewController.updateAvatar(url: testUrl)

      // then
      XCTAssertTrue(viewController.viewDidUpdateAvatar)
    }
}
