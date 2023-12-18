//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 18.12.2023.
//

import Foundation

final class ImagesListService {
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    private var task: URLSessionTask?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private var authToken: String? {
        return OAuth2TokenStorage().token
    }
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        task?.cancel()
        
        guard let request = makeRequest() else { return }
        let task = URLSession.shared.objectTask(for: request) { [weak self]
            (result:Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photoResult):
                let photos = photoResult.compactMap { photoResult in
                    return Photo(id: photoResult.id!,
                                 size: CGSize(width: photoResult.width!, height: photoResult.height!),
                                 createdAt: self.dateFormatter.date(from: photoResult.created_at!),
                                 welcomeDescription: photoResult.description!,
                                 thumbImageURL: photoResult.urls!.thumb!,
                                 largeImageURL: photoResult.urls!.full!,
                                 isLiked: photoResult.liked_by_user!
                    )
                }
                DispatchQueue.main.async { [weak self] in
                    self?.photos.append(contentsOf: photos)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                }
            case .failure(let error):
                break
                //TODO: delete , add completion
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest() -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURLString)/photos") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let lastLoadedPage = self.lastLoadedPage != nil ? self.lastLoadedPage : 1
        request.setValue(lastLoadedPage?.description, forHTTPHeaderField: "page")
    
        return request
    }
}

struct PhotoResult: Codable {
    let id: String?
    let created_at: String?
    let updated_at: String?
    let width: Int?
    let height: Int?
    let color: String?
    let blur_hash: String?
    let likes: Int?
    let liked_by_user: Bool?
    let description: String?
    let urls: UrlsResult?
}


struct UrlsResult: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
