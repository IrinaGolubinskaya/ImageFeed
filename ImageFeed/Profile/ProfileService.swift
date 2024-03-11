//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 07.11.2023.

import UIKit

final class ProfileService {
    static let shared = ProfileService()
    
    private var authToken: String? {
        return OAuth2TokenStorage().token
    }
    
    private var task: URLSessionTask?
    
    private(set) var profile: Profile?
    
    private init(task: URLSessionTask? = nil, profile: Profile? = nil) {
        self.task = task
        self.profile = profile
    }
    
    private func makeRequest() -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURL.absoluteString)/me") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeRequest() else { return }
        let task = URLSession.shared.objectTask(for: request) { [weak self]
            (result:Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let profileResult):
                let profile = Profile(
                    username: profileResult.username,
                    firstName: profileResult.firstName ?? "",
                    lastName: profileResult.lastName ?? "",
                    bio: profileResult.bio ?? ""
                )
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
}
