//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 03.10.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
        case accessToken =  "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
    
    func getResponce(from jsonString: String) -> OAuthTokenResponseBody? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        do {
            let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
            return response
        } catch {
            print("error")
            return nil
        }
    }
}
