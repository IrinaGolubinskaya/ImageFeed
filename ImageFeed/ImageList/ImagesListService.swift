//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 18.12.2023.
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let dateFormatter = ISO8601DateFormatter()
    
    private var authToken: String? {
        return OAuth2TokenStorage().token
    }
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        task?.cancel()
        
        guard let request = makeRequest() else {
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self]
            (result:Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photoResult):
                
                let photos = photoResult.compactMap { photoResult in
                    return Photo(id: photoResult.id ?? "",
                                 size: CGSize(width: photoResult.width ?? .zero, height: photoResult.height ?? .zero),
                                 createdAt: self.dateFormatter.date(from: photoResult.createdAt ?? ""),
                                 welcomeDescription: photoResult.description,
                                 thumbImageURL: photoResult.urls?.thumb ?? "",
                                 largeImageURL: photoResult.urls?.full ?? "",
                                 isLiked: photoResult.likedByUser ?? false
                    )
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.photos.append(contentsOf: photos)
                    
                    if self?.lastLoadedPage != nil {
                        self?.lastLoadedPage! += 1
                    } else {
                        self?.lastLoadedPage = 2
                    }
                    
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                }
            case .failure(_):
                break
            }
        }
        
        self.task = task
        task.resume()
    }
    
    func changeLike(
        photoId: String,
        isLiked: Bool,
        _ completion: @escaping (Result<Void, Error>
        ) -> Void) {
        guard let request = makeLikeRequest(id: photoId, isLiked: isLiked) else {
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self]
            (result:Result<PhotoResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where:  {$0.id == photoId }) {
                    DispatchQueue.main.async { [ weak self] in
                        guard let self else { return }
                        self.photos[index].changeLike()
                        completion(.success(()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    private func makeLikeRequest(id: String, isLiked: Bool) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURLString)/photos/\(id)/like") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLiked ? "DELETE" : "POST"
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    private func makeRequest() -> URLRequest? {
        let path = "\(Constants.defaultBaseURLString)/photos"
        
        guard let lastLoadedPage = self.lastLoadedPage != nil ? self.lastLoadedPage : 1 else {
            return nil
        }
        
        let items = [URLQueryItem(name: "page", value: lastLoadedPage.description)]
        var urlComponents = URLComponents(string: path)
        urlComponents?.queryItems = items
        
        guard let url = urlComponents?.url else { return nil }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}
