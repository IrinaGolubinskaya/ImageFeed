//
//  ViewController.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 31.07.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private var imageListServiceObserver: NSObjectProtocol?

    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private let photosName: [String] = Array(0..<20).map{"\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                //TODO:
            }
    }
    
    // MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
        guard segue.identifier == showSingleImageSegueIdentifier,
              let viewController = segue.destination as? SingleImageViewController,
              let indexPath = sender as? IndexPath else {
            super.prepare(for: segue, sender: sender)
            return
        }
        let image = UIImage(named: photosName[indexPath.row])
        viewController.image = image
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }
        
        let image = UIImage(named: photosName[indexPath.row])
        let date = dateFormatter.string(from: Date())
        let isLiked = indexPath.row % 2 == 0
        
        imageListCell.configure(image: image, date: date, isLiked: isLiked)
        
        return imageListCell
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    ///Вызывается прямо перед тем, как ячейка таблицы будет показана на экране. В этом методе можно проверить условие indexPath.row + 1 == photos.count, и если оно верно — вызывать fetchPhotosNextPage(). Нужно сделать так, чтобы многократные вызовы fetchPhotosNextPage() были «дешёвыми» по ресурсам и не приводили к прерыванию текущего сетевого запроса.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //TODO: 
    }
}
