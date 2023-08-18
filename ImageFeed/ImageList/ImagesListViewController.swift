//
//  ViewController.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 31.07.2023.
//

import UIKit

class ImagesListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configCell(for cell: ImageListCell) {
        cell.getDate()
    }
}
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }
       // configCell(for: imageListCell)
        return imageListCell
    }
    
    
}

extension ImagesListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}
