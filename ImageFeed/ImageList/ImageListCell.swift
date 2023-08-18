//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 15.08.2023.
//

import UIKit

final class ImageListCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImageListCell"
    
    func getDate() {
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .medium
        dateLabel.text = formatter1.string(from: today)
    }
//
//    @IBAction func activeFavourite(_ sender: Any) {
//    }
}
    
