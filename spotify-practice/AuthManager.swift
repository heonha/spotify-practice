//
//  AuthManager.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {
        
    }
    
    var isSignIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false 
    }
    
    
}
