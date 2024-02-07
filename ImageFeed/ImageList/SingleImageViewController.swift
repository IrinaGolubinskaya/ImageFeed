//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 28.08.2023.
//

import UIKit
import ProgressHUD

final class SingleImageViewController: UIViewController {
    
    var image: UIImage?
    
    var url: URL?
    
    @IBOutlet private var fullImageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        present(share,animated: true)
    }
    
    @IBAction func backwardButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func downloadImage() {
        UIBlockingProgressHUD.show()
        fullImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeHolder")) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let result):
                let image = result.image
                self?.image = image
                self?.rescaleAndCenterImageInScrollView(image: image)
            case .failure(_):
                self?.showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Что-то пошло не так.",
                                      message: "Попробовать ещё раз?",
                                      preferredStyle: .alert)
        let hideAlertAction = UIAlertAction(title: "Не надо", style: .cancel)
        let repeatAlertAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.downloadImage()
        }
        
        alert.addAction(hideAlertAction)
        alert.addAction(repeatAlertAction)
        present(alert, animated:  true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func setCenterImage() {
        let visibleRectSize = scrollView.bounds.size
        let contentSize = scrollView.contentSize
        
        var xOffset: CGFloat = 0.0
        var yOffset: CGFloat = 0.0
        
        if contentSize.width < visibleRectSize.width {
            xOffset = (visibleRectSize.width - contentSize.width) * 0.5
        }
        
        if contentSize.height < visibleRectSize.height {
            yOffset = (visibleRectSize.height - contentSize.height) * 0.5
        }
        
        scrollView.contentInset = UIEdgeInsets(top: yOffset, left: xOffset, bottom: 0, right: 0)
    }
}

// MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        fullImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setCenterImage()
    }
}
