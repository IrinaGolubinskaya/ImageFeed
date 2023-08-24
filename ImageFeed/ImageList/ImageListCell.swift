//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 15.08.2023.
//

import UIKit

final class ImageListCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    static let reuseIdentifier = "ImageListCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // setupGradientView()
    }
    
    @IBAction func favouriteButtonActive(_ sender: Any) { }
    
    //    private func setupGradientView() {
    //        let gradient = CAGradientLayer()
    //        gradient.frame = gradientView.frame
    //        gradient.colors = [
    //            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor,
    //            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1).cgColor
    //        ]
    //        gradient.locations = [0,1]
    //        gradient.startPoint = CGPoint(x: 0, y: 0.5)
    //        gradient.endPoint = CGPoint(x: 1, y: 0.5)
    //        gradientView.layer.insertSublayer(gradient, at: 0)
    //    }
    
}

extension ImageListCell {
    func configure(image: UIImage?, date: String, isLiked: Bool) {
        mainImageView.image = image
        dateLabel.text = date
        let likeImage = isLiked ? UIImage(named: "activeFavourite") : UIImage(named: "favourite")
        favouriteButton.setImage(likeImage, for: .normal)
    }
}

