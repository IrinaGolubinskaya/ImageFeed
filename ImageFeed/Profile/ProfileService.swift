//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 07.11.2023.
//

import UIKit

final class ProfileService {
    static let shared = ProfileService()
    
    private var authToken: String? {
        return OAuth2TokenStorage().token
    }
    
    private var task: URLSessionTask?
    
    private(set) var profile: Profile?
    
    private func makeRequest()-> URLRequest? {
        guard let url = URL(string: Constants.unsplashBaseURLString) else { return nil }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = makeRequest() else { return }
        let task = object(for: request) {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                let profile = Profile(
                    username: profileResult.userName,
                    firstName: profileResult.firstName,
                    lastName: profileResult.lastName,
                    bio: profileResult.bio
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
    
    private func object(
        for request: URLRequest,
        completion: @escaping( Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return URLSession.shared.data(for: request) { (result: Result<Data,Error>) in
            let response = result.flatMap { data -> Result< ProfileResult,Error> in
                Result {
                    try decoder.decode(ProfileResult.self, from: data)
                }
            }
            completion(response)
        }
    }
}

struct ProfileResult: Codable {
    
    // let id: String
    // let updatedAt : String
    
    let userName: String
    let firstName: String
    let lastName: String
    // let profile_image: String
    // let twitterUsername: String
    // let portfolioUrl: URL?
    let bio: String
    // let location: String
    // let totalLikes: Int
    // let totalPhotos: Int
    // let totalCollections: Int
    // let followedByUser: Bool
    // let downloads: Int
    // let uploadsRemaining: Int
    // let instagramUsername: String
    //  let location: String?
    //  let email: String
    //  let links: Links
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userName = try container.decode(String.self, forKey: .userName)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.bio = try container.decode(String.self, forKey: .bio)
    }
    
    private func getProfileResult(from jsonString: String) -> ProfileResult? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        do {
            let profileResponse = try JSONDecoder().decode(ProfileResult.self, from: data)
            return profileResponse
        } catch {
            print("error")
            return nil
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        // case id
        // case updatedAt = "updatedAt"
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        // case twitterUsername = "twitter_username"
        // case portfolioUrl = "portfolio_url"
        case bio
        //   case location
        // case totalLikes = "total_likes"
        //  case totalPhotos = "total_photos"
        //  case totalCollections = "total_collections"
        //  case followedByUser = "followed_by_user"
        //  case downloads
        //  case uploadsRemaining = "uploads_remaining"
        // case instagramUsername = "instagram_username"
        // case location
        // case email
    }
}
struct Links {
    let selfLink: String
    let html: String
    let photos: String
    let likes: String
    let portfolio: String
    
    private enum CodingKeys: String, CodingKey {
        case selfLink = "self"
    }
}
