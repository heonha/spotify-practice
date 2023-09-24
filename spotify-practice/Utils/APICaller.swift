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
    
    typealias UserProfileResult = Result<UserProfile, Error>
    
    enum Constant {
        static let baseURL = "https://api.spotify.com/v1"
    }
    
}

extension APICaller {
    
    func getCurrentUserProfile(token: String?, completion: @escaping (UserProfileResult) -> Void) {
        
        guard let token = token else {
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

        let endpoint = "/me"
        let header = HttpHeader.bearerTokenHeader(token: token)

        networkService.GET(headerType: header,
                           urlString: Constant.baseURL,
                           endPoint: endpoint,
                           parameters: [:],
                           returnType: UserProfile.self)
        .timeout(10, scheduler: DispatchQueue.global())
        .retry(2)
        .receive(on: RunLoop.main)
        .sink { result in
            switch result {
            case .finished:
                break
            case .failure(let error):
                completion(.failure(error))
            }
        } receiveValue: { profile in
            completion(.success(profile))
        }
        .store(in: &cancellables)
    }
    
}


enum APICallerError: Error {
    case invalidToken(message: String = "")
}
