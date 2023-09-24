//
//  AccountViewModel.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/24/23.
//

import Foundation

final class AccountViewModel {
    
    private let apiCaller = APICaller.shared
    private let authManager = AuthManager.shared
    
    func getProfile(completion: @escaping(Result<UserProfile, Error>) -> Void) {
        guard let token = authManager.getAccessToken() else { return }
        apiCaller.getCurrentUserProfile(token: token) { result in
            completion(result)
        }
    }
    
    
}
