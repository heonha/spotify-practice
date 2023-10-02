//
//  User.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/2/23.
//

import Foundation

struct User: Codable {
    let id: String
    let displayName: String
    let externalUrls: [String: String]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case externalUrls = "external_urls"
    }
}
