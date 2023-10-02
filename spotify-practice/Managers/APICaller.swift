//
//  APICaller.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/24/23.
//

import Foundation
import Combine

final class APICaller: CombineProtocol {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    static let shared = APICaller()
    
    private let networkService = NetworkService.shared
    
    enum Constant {
        static let baseURL = "https://api.spotify.com/v1"
        static let getNewReleases = "/browse/new-releases"
        static let getAllFeaturedPlaylists = "/browse/featured-playlists"
        static let getCurrentUserProfile = "/me"
    }
    
}

extension APICaller {
    
    
    func createRequest<T: Codable>(method: HttpMethod,
                                   endpoint: String,
                                   parameters: [String: String] = [:],
                                   completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let token = AuthManager.shared.getToken() else {
            return completion(.failure(APICallerError.invalidToken(message: "엑세스 토큰이 없습니다.")))
        }
        
        AuthManager.shared.checkShouldRefreshToken { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                completion(.failure(APICallerError.invalidToken(message: error.localizedDescription)))
            }
        }
        
        let header = HttpHeader.bearerTokenHeader(token: token)
        
        networkService.request(method: method,
                               headerType: header,
                               urlString: Constant.baseURL,
                               endPoint: endpoint,
                               parameters: parameters,
                               returnType: T.self)
        .timeout(10, scheduler: DispatchQueue.global())
        .retry(2)
        .receive(on: DispatchQueue.main)
        .sink { result in
            switch result {
            case .finished:
                break
            case .failure(let error):
                completion(.failure(error))
            }
        } receiveValue: { data in
            completion(.success(data))
        }
        .store(in: &cancellables)
    }
    
    /// 유저 프로필 가져오기
    func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(method: .GET, endpoint: "/me", completion: completion)
    }
    
    /// 신규 앨범 가져오기
    func getNewReleases(limit: Int = 2, completion: @escaping ((Result<NewReleaseResponse, Error>) -> Void)) {
        let parameters = ["limit" : limit.description]
        createRequest(method: .GET, endpoint: Constant.getNewReleases, parameters: parameters, completion: completion)
    }
    
    /// 모든 추천 플레이리스트 가져오기
    func getAllFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistsResponse, Error>) -> Void)) {
        createRequest(method: .GET, endpoint: Constant.getAllFeaturedPlaylists, parameters: [:], completion: completion)
    }
    
}
