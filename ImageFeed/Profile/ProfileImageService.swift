//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 08.11.2023.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private (set) var avatarURL: URL?
    private var task: URLSessionTask?
    
    private var authToken: String? {
        return OAuth2TokenStorage().token
    }
    
    private init(avatarURL: URL? = nil, task: URLSessionTask? = nil) {
        self.avatarURL = avatarURL
        self.task = task
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeRequest(username: username) else { return
            assertionFailure("Не верный запрос")
        }
                
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
                
            case .success(let userResult):
                guard let mediumPhoto = userResult.profileImage?.medium else { return }
                self.avatarURL = URL(string: mediumPhoto)
                completion(.success(mediumPhoto))
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": mediumPhoto])
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    
    
    private func makeRequest(username: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURLString)/me") else { return nil }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}

struct UserResult: Codable {
    let profileImage: ProfileImage?
}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}
