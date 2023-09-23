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
    
    var signInURL: URL? {
        let baseURL = "https://accounts.spotify.com/authorize"
        let code = "code"
        let scope = "user-read-private"
        let redirectURI = "https://website.heon.dev".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let parameter = "?response_type=\(code)&client_id=\(Keys.clientId)&scope=\(scope)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        let url = URL(string: baseURL + parameter)
        return url
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
