//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 28.08.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            fullImageView.image = image
        }
    }
    
    @IBOutlet var fullImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullImageView.image = image
        }
}
