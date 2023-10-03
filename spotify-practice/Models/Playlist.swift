//
//  Playlist.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/2/23.
//

import Foundation

struct Playlist: Codable {
    let id: String
    let name: String
    let description: String
    let externalUrls: [String: String]
    let images: [APIImage]
    let owner: User
    
    private enum CodingKeys: String, CodingKey {
        case id, name, description, images, owner
        case externalUrls = "external_urls"
    }
}
