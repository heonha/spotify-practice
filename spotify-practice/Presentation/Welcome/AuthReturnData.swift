//
//  AuthReturnData.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

import Foundation

struct AuthReturnData: Codable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String?
    let scope: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
    }
}
