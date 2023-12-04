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
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeRequest(username: username) else { return
            assertionFailure("Не верный запрос")
            // TODO: написать конкретно ошибку и вызвать комплишн с кейсом из энама с ошибкой invalidRequest
        }
        
        print("request.url?.absoluteString",request.url?.absoluteString)
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
                
            case .success(let userResult):
                dump(userResult)
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

    private func object(
        for request: URLRequest,
        completion: @escaping( Result<UserResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return URLSession.shared.data(for: request) { (result: Result<Data,Error>) in
            let response = result.flatMap { data -> Result< UserResult,Error> in
                Result {
                    try decoder.decode(UserResult.self, from: data)
                }
            }
            completion(response)
        }
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
