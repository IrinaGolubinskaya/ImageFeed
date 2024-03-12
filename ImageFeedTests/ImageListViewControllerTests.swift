//
//  ImageListViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Irina Golubinskaya on 12.03.2024.
//

import XCTest
@testable import ImageFeed

final class ImageListTests: XCTestCase {
    
    let viewController = ImagesListViewControllerMock()
    let indexPath = IndexPath(row: 1, section: 0)
    
    override func setUpWithError() throws { }
    
    func testUpdateTableViewAnimated() {
        viewController.updateTableViewAnimated()
        
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
    
    func testCalcHeightForRowAt() {
        let result = viewController.calcHeightForRowAt(indexPath: indexPath)
        
        XCTAssertTrue(viewController.calcHeightForRowAtCalled)
        XCTAssertTrue(viewController.calcHeightForRowAtIndex)
        XCTAssertEqual(result, CGFloat(100))
    }
    
    func testCheckNeedLoadNextPhotos() {
        viewController.checkNeedLoadNextPhotos(indexPath:indexPath)
        
        XCTAssertTrue(viewController.checkNeedLoadNextPhotosCalled)
        XCTAssertTrue(viewController.checkNeedLoadNextPhotosIndex)
    }
    
    func testReturnPhotoModelAt() {
        _ = viewController.returnPhotoModelAt(indexPath: indexPath)
        
        XCTAssertTrue(viewController.returnPhotoModelAtCalled)
        XCTAssertTrue(viewController.returnPhotoModelAtIndex)
    }
    
}
