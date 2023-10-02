//
//  AuthManager.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

import Foundation
import Combine

final class AuthManager {
    
    typealias RequestResult = Result<SuccessType, Error>
    
    static let shared = AuthManager()
    private let networkService = NetworkService.shared
    var cancellables = Set<AnyCancellable>()
    
    private struct Constant {
        static let requestTokenURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://website.heon.dev"
        static let baseURL = "https://accounts.spotify.com/authorize"
        static let scope = "user-read-private playlist-modify-public playlist-read-private playlist-modify-private user-follow-read user-library-modify user-library-read user-read-email"
    }
    
    private init() {}
    
    var signInURL: URL? {
        let code = "code"
        let parameter = "?response_type=\(code)&client_id=\(Keys.clientId)&scope=\(Constant.scope)&redirect_uri=\(Constant.redirectURI)&show_dialog=TRUE"
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
    
    /// Token 유효 기간이 이 5분 이내로 남았을 때 refresh token을 이용하여 토큰을 갱신합니다.
    public func checkShouldRefreshToken(completion: ((RequestResult) -> Void)?) {
        guard let expirationDate = tokenExpirationDate else {
            completion?(.failure(AuthError.shoudNotRefreshToken(message: "토큰 만료일이 없습니다.")))
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            completion?(.failure(AuthError.shoudNotRefreshToken(message: "Refresh Token 값이 없습니다.")))
            return
        }
        
        let shouldRefresh = expirationDate < Date().addingTimeInterval(.init(300))
        
        if shouldRefresh {
            self.getTokenFromRefreshToken(refreshToken: refreshToken, completion: completion)
        } else {
            completion?(.success(.normal))
        }
    }
    
    func getToken() -> String? {
        return accessToken
    }
    
    /// 로그인 시 서버에서 code를 발급받아 access token을 발급받습니다.
    public func getTokenFromCode(code: String, completion: @escaping(RequestResult) -> Void) {
        guard let url = URL(string: Constant.requestTokenURL) else { return }
        
        let header = HttpHeader.basicTokenHeader(clientId: Keys.clientId, clientSecret: Keys.clientSecret)
        let body = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": Constant.redirectURI
        ]
        
        self.requestTokenWithAPI(url: url, header: header, body: body, completion: completion)
    }
    
    /// refresh token을 이용하여 access token을 갱신합니다.
    public func getTokenFromRefreshToken(refreshToken: String, completion: ((RequestResult) -> Void)?) {
        
        guard let url = URL(string: Constant.requestTokenURL) else {
            completion?(.failure(AuthError.refreshTokenIsNil()))
            return
        }
        
        let header = HttpHeader.basicTokenHeader(clientId: Keys.clientId, clientSecret: Keys.clientSecret)
        let body = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
            "client_id": Keys.clientId
        ]
        
        requestTokenWithAPI(url: url, header: header, body: body, completion: completion)
        
    }
    
    /// 서버에 RESTful API를 통해 토큰을 요청합니다.
    private func requestTokenWithAPI(url: URL,
                                     header: HttpHeader,
                                     body: [String : String],
                                     completion: ((RequestResult) -> Void)?) {
        networkService
            .request(method: .POST,
                     headerType: header,
                     urlString: url.absoluteString,
                     endPoint: "",
                     parameters: body,
                     returnType: AuthReturnData.self)
            .timeout(10, scheduler: DispatchQueue.global())
            .receive(on: RunLoop.main)
            .sink { result in
                switch result {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error)
                    completion?(.failure(error))
                }
            } receiveValue: { [weak self] authData in
                print("Auth-data-debug: \(authData)")
                self?.cacheToken(authData)
                completion?(.success(.normal))
            }
            .store(in: &cancellables)
    }
    
    /// UserDefaults로 토큰을 캐시합니다. (평문 저장)
    private func cacheToken(_ token: AuthReturnData) {
        UserDefaults.standard.setValue(token.accessToken, forKey: UserDefaultsKeys.accessToken)
        
        if token.refreshToken != nil {
            UserDefaults.standard.setValue(token.refreshToken, forKey: UserDefaultsKeys.refreshToken)
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(.init(token.expiresIn)), forKey: UserDefaultsKeys.expiresIn)
    }
    
    public func getAccessToken() -> String? {
        return self.accessToken
    }
    
}
