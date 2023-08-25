//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 15.08.2023.
//

import UIKit

final class ImageListCell: UITableViewCell {
    
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var favouriteButton: UIButton!
    @IBOutlet private weak var gradientView: UIView!
    
    static let reuseIdentifier = "ImageListCell"
    
    @IBAction func favouriteButtonActive(_ sender: Any) { }
}

extension ImageListCell {
    func configure(image: UIImage?, date: String, isLiked: Bool) {
        mainImageView.image = image
        dateLabel.text = date
        let likeImage = isLiked ? UIImage(named: "activeFavourite") : UIImage(named: "favourite")
        favouriteButton.setImage(likeImage, for: .normal)
    }
}

