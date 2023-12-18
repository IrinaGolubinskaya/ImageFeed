//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Irina Golubinskaya on 05.10.2023.
//

import Foundation

final class OAuth2Service {
    
    private(set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    var isAuthorized: Bool {
        OAuth2TokenStorage().token != nil
    }
    
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private var task : URLSessionTask?
    private var lastCode: String? /// код необходимый для создания токена
    
    
    private init(task: URLSessionTask? = nil, lastCode: String? = nil) {
        self.task = task
        self.lastCode = lastCode
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>)-> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        guard let request = makeAuthTokenRequest(code: code) else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (result:Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
                self.task = nil
            case .failure(let error):
                self.lastCode = nil
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    
    private func makeAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: Constants.unsplashBaseURLString) else { return nil }
        return  URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: baseURL
        )
    }
}

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL
    )-> URLRequest? {
        guard let url = URL(string: path, relativeTo: baseURL) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession{
    func data(
        for request: URLRequest,
        completition: @escaping (Result<Data,Error>)-> Void) -> URLSessionTask {
            let fulfillCompletion: (Result<Data,Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completition(result)
                }
            }
            let task = dataTask(with: request, completionHandler: { data, response, error in
                if let data = data,
                   let response = response,
                   let statusCode = (response as? HTTPURLResponse)?.statusCode
                {
                    if 200 ..< 300 ~= statusCode {
                        fulfillCompletion(.success(data))
                    } else {
                        fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                } else if let error = error {
                    fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                } else {
                    fulfillCompletion(.failure(NetworkError.urlSessionError))
                }
            })
            task.resume()
            return task
        }
}
