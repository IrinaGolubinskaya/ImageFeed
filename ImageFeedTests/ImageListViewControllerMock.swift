//
//  ImageListViewControllerMock.swift
//  ImageFeedTests
//
//  Created by Irina Golubinskaya on 12.03.2024.
//

import UIKit
@testable import ImageFeed

final class ImagesListViewControllerMock: UIViewController {
    var updateTableViewAnimatedCalled = false
    var calcHeightForRowAtCalled = false
    var calcHeightForRowAtIndex = false
    var checkNeedLoadNextPhotosCalled = false
    var checkNeedLoadNextPhotosIndex = false
    var returnPhotoModelAtCalled = false
    var returnPhotoModelAtIndex = false
    var imagesListCellDidTapLikeCalled = false
    var imagesListCellDidTapLikeGotIndex = false
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
    
    func calcHeightForRowAt(indexPath: IndexPath) -> CGFloat {
        calcHeightForRowAtCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            calcHeightForRowAtIndex = true
        }
        return CGFloat(100)
    }
    
    func checkNeedLoadNextPhotos(indexPath: IndexPath) {
        checkNeedLoadNextPhotosCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            checkNeedLoadNextPhotosIndex = true
        }
    }
    
    func returnPhotoModelAt(indexPath: IndexPath) -> Photo? {
        returnPhotoModelAtCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            returnPhotoModelAtIndex = true
        }
        return nil
    }
    
    func imagesListCellDidTapLike(_ cell: ImageListCell, indexPath: IndexPath) {
        imagesListCellDidTapLikeCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            imagesListCellDidTapLikeGotIndex = true
        }
    }
}
