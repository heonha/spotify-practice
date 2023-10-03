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
        static let getAllRecommendations = "/recommendations"
        static let getAllRecommendationsGenre = "/recommendations/available-genre-seeds"
        
        static func getAlbum(id: String) -> String {
            return "/albums/\(id)"
        }
        
        static func getPlaylist(id: String) -> String {
            return "/playlists/\(id)"
        }

    }
    
}

extension APICaller {
    
    // MARK: - Albums
    func getAlbumDetails(for album: Album, completion: @escaping(Result<AlbumDetailResponse, Error>) -> Void) {
        createRequest(method: .GET, endpoint: Constant.getAlbum(id: album.id), parameters: [:], completion: completion)
    }
    
    // MARK: - Playlists
    
    func getPlaylistDetails(for playlist: Playlist, completion: @escaping(Result<PlaylistDetailResponse, Error>) -> Void ) {
        createRequest(method: .GET, endpoint: Constant.getPlaylist(id: playlist.id), parameters: [:], completion: completion)
    }
    
    // MARK: - Profile
    
    
    
    func createRequest<T: Codable>(method: HttpMethod,
                                   endpoint: String,
                                   parameters: [String: String] = [:],
                                   completion: @escaping (Result<T, Error>) -> Void) {
        
        AuthManager.shared.checkShouldRefreshToken { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                completion(.failure(APICallerError.invalidToken(message: error.localizedDescription)))
            }
        }
        
        guard let token = AuthManager.shared.getToken() else {
            return completion(.failure(APICallerError.invalidToken(message: "엑세스 토큰이 없습니다.")))
        }
        
        let header = HttpHeader.bearerTokenHeader(token: token)
        
        networkService.request(method: method,
                               headerType: header,
                               urlString: Constant.baseURL,
                               endPoint: endpoint,
                               parameters: parameters,
                               returnType: T.self)
        .timeout(5, scheduler: DispatchQueue.global())
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
            print("DEBUG: \(data)")
            completion(.success(data))
        }
        .store(in: &cancellables)
    }
    
    /// 유저 프로필 가져오기
    func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(method: .GET, endpoint: "/me", completion: completion)
    }
    
    /// 신규 앨범 가져오기
    func getNewReleases(limit: Int = 10, completion: @escaping ((Result<NewReleaseResponse, Error>) -> Void)) {
        let parameters = ["limit" : limit.description]
        createRequest(method: .GET, endpoint: Constant.getNewReleases, parameters: parameters, completion: completion)
    }
    
    /// 모든 추천 플레이리스트 가져오기
    func getAllFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistsResponse, Error>) -> Void)) {
        createRequest(method: .GET, endpoint: Constant.getAllFeaturedPlaylists, parameters: [:], completion: completion)
    }
    
    /// 모든 추천 정보 가져오기
    func getAllRecommendations(limit: Int = 10, genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>) -> Void)) {
        print("MSG: getAllRecommendations를 요청합니다")

        let seeds = genres.joined(separator: ",")
        let parameters = [
            "seed_genres": seeds,
            "limit" : limit.description
        ]
        createRequest(method: .GET, endpoint: Constant.getAllRecommendations, parameters: parameters, completion: completion)
    }
    
    /// 모든 장르 가져오기
    func getAllRecommendationGenres(completion: @escaping ((Result<RecommendedGenresResponse, Error>) -> Void)) {
        print("MSG: getAllRecommendationGenres를 요청합니다")
        createRequest(method: .GET, endpoint: Constant.getAllRecommendationsGenre, completion: completion)
    }
    
}
