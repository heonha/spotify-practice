//
//  AuthManager.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

import Foundation
import Combine

final class AuthManager {
    
    
    static let shared = AuthManager()
    private let networkService = NetworkService()
    var cancellables = Set<AnyCancellable>()
    
    struct Constant {
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://website.heon.dev"
        static let baseURL = "https://accounts.spotify.com/authorize"
    }
    
    private init() {
        
    }
    
    var signInURL: URL? {
        let code = "code"
        let scope = "user-read-private"
        // let redirectURI = "spotify-ios-quick-start://spotify-login-callback"
        let parameter = "?response_type=\(code)&client_id=\(Keys.clientId)&scope=\(scope)&redirect_uri=\(Constant.redirectURI)&show_dialog=TRUE"
        let url = URL(string: Constant.baseURL + parameter)
        return url
    }
    
    var isSignIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refreshToken")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expiresIn") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else { return false }
        return expirationDate < Date().addingTimeInterval(.init(300))
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping(Bool) -> Void) {
        guard let url = URL(string: Constant.tokenAPIURL) else { return }
        
        let headerType = HeaderType.basicTokenHeader(clientId: Keys.clientId, clientSecret: Keys.clientSecret)
        let body = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": Constant.redirectURI
        ]
        
        networkService
            .POST(headerType: headerType, 
                  urlString: url.absoluteString,
                  endPoint: "",
                  body: body,
                  returnType: SpotifyAuthReturnType.self)
            .timeout(10, scheduler: DispatchQueue.global())
            .receive(on: RunLoop.main)
            .sink { result in
                switch result {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error)
                    completion(false)
                }
            } receiveValue: { [weak self] authData in
                print("Auth-data-debug: \(authData)")
                self?.cacheToken(authData)
                completion(true)
            }
            .store(in: &cancellables)
        
    }
    
    func cacheToken(_ token: SpotifyAuthReturnType) {
        UserDefaults.standard.setValue(token.accessToken, forKey: "accessToken")
        UserDefaults.standard.setValue(token.refreshToken, forKey: "refreshToken")
        UserDefaults.standard.setValue(Date().addingTimeInterval(.init(token.expiresIn)), forKey: "expiresIn")
    }
    
}

struct SpotifyAuthReturnType: Codable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String
    let scope: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
    }
}
