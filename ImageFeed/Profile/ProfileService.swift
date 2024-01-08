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
        guard let url = URL(string: "\(Constants.defaultBaseURLString)/me") else { return nil }
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

struct ProfileResult: Decodable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
    
    private enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
        case profileImage = "profile_image"
    }
}

struct Links: Decodable {
    let selfLink: String
    let html: String
    let photos: String
    let likes: String
    let portfolio: String
    
    private enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case html
        case photos
        case likes
        case portfolio
    }
}

struct Social: Decodable {
    let instagramUsername: String
    let portfolioURL: String
    let twitterUsername: String
    
    private enum CodingKeys: String, CodingKey {
        case instagramUsername = "instagram_username"
        case portfolioURL = "portfolio_url"
        case twitterUsername = "twitter_username"
    }
}

struct Badge: Decodable {
    let title: String
    let primary: Bool
    let slug: String
    let link: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case primary
        case slug
        case link
    }
}
