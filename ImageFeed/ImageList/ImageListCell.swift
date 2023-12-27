//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 15.08.2023.
//

import UIKit
import Kingfisher

final class ImageListCell: UITableViewCell {
    
    let imagesListService = ImagesListService.shared
    
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var favouriteButton: UIButton!
    @IBOutlet private weak var gradientView: UIView!
    
    static let reuseIdentifier = "ImageListCell"

    var photoId: String?
    var isLiked: Bool?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainImageView.kf.cancelDownloadTask()
        mainImageView.image = nil
    }
    
    @IBAction func favouriteButtonActive(_ sender: Any) {
        changeLikeButton()
    }
    
    private func changeLikeButton() {
        guard let photoId = photoId else { return }
        guard let isLiked = isLiked else { return }
        imagesListService.changeLike(photoId: photoId, isLiked: isLiked) { result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self.isLiked = !isLiked
                    let likeImage = isLiked ? UIImage(named: "activeFavourite") : UIImage(named: "favourite")
                    self.favouriteButton.setImage(likeImage, for: .normal)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ImageListCell {
    
    func configure(url: URL, date: String, isLiked: Bool, photoId: String) {
        mainImageView.kf.indicatorType = .activity
        mainImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeHolder")) { [weak self] result in
            //TODO: - вызвать обновление из VC
        }
        dateLabel.text = date
        self.photoId = photoId
        self.isLiked = isLiked
        let likeImage = isLiked ? UIImage(named: "activeFavourite") : UIImage(named: "favourite")
        favouriteButton.setImage(likeImage, for: .normal)
    }
}
