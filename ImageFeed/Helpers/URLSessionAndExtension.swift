//
//  URLSessionAndExtension.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 14.11.2023.
//

import Foundation

extension URLSession {
    
    func objectTask<T:Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        
        let fullFillCompletionMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                if 200 ..< 300 ~= statusCode {
                    
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fullFillCompletionMainThread(.success(result))
                    } catch {
                        print(String(describing: error))
                        fullFillCompletionMainThread(.failure(error))
                    }
                } else if let error {
                    fullFillCompletionMainThread(.failure(error))
                }
            } else if let error = error {
                fullFillCompletionMainThread(.failure(error))
            }
        }
        return task
    }
}
