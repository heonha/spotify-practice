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
        apiCaller.getCurrentUserProfile { result in
            completion(result)
        }
    }
    
    
}
