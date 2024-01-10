//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 15.08.2023.
//

import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImageListCell)
}

final class ImageListCell: UITableViewCell {
    
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var favouriteButton: UIButton!
    @IBOutlet private weak var gradientView: UIView!
    
    static let reuseIdentifier = "ImageListCell"
    
    weak var delegate: ImageListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainImageView.kf.cancelDownloadTask()
        mainImageView.image = nil
    }
    
    func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "activeFavourite") : UIImage(named: "favourite")
        self.favouriteButton.setImage(likeImage, for: .normal)
    }
    
    @IBAction func favouriteButtonActive(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}

extension ImageListCell {
    
    func configure(url: URL, date: String, isLiked: Bool) {
        mainImageView.kf.indicatorType = .activity
        mainImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeHolder")) 
        dateLabel.text = date
        let likeImage = isLiked ? UIImage(named: "activeFavourite") : UIImage(named: "favourite")
        favouriteButton.setImage(likeImage, for: .normal)
    }
}
