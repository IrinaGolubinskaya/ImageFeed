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
    
//    init(from decoder: Decoder) throws {
//        let container =  try decoder.container(keyedBy: CodingKeys.self)
//        accessToken = try container.decode(String.self, forKey: .accessToken)
//        tokenType = try container.decode(String.self, forKey: .tokenType)
//        scope = try container.decode(String.self, forKey: .scope)
//        createdAt = try container.decode(Int.self, forKey: .createdAt)
//    }
    
    private enum CodingKeys: String, CodingKey {
        case accessToken =  "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
    
    func getResponce(from jsonString: String) -> OAuthTokenResponseBody? {
        guard let data = jsonString.data(using: .utf8) else {return nil}
        do {
            let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
            return response
        } catch {
            print("error")
            return nil
        }
    }
}
