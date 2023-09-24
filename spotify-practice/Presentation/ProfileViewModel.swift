//
//  ProfileViewModel.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/24/23.
//

import Foundation

final class ProfileViewModel {
    
    private let apiCaller = APICaller.shared
    private let authManager = AuthManager.shared
    
    func getProfile() {
        guard let token = authManager.getAccessToken() else { return }
        apiCaller.getCurrentUserProfile(token: token) { result in
            switch result {
            case .success(let profile):
                print("profile --> \(profile.id)")
            case .failure(let error):
                print("profile fetch Error: \(error)")
            }
        }
    }
    
    
}
