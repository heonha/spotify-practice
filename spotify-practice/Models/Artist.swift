//
//  Artist.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/2/23.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let externalUrls: [String: String]
    
    private enum CodingKeys: String, CodingKey {
        case id, name, type
        case externalUrls = "external_urls"
    }
}
