//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 08.11.2023.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    
    private var authToken: String? {
        return OAuth2TokenStorage().token
    }
    
    private (set) var avatarURL: String?
    
    private var task: URLSessionTask?

    private func makeRequest()-> URLRequest? {
        guard let url = URL(string: "\(Constants.unsplashBaseURLString)/users/:username") else { return nil }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeRequest() else { return }
        let task = object(for: request) {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userResult):
                let avatarURL = userResult.profileImage.small
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
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
    let profileImage: ProfileImage
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.profileImage = try container.decode(ProfileImage.self, forKey: .profileImage)
    }
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.small = try container.decode(String.self, forKey: .small)
        self.medium = try container.decode(String.self, forKey: .medium)
        self.large = try container.decode(String.self, forKey: .large)
    }
}
