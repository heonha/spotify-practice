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
    let external_urls: [String]
    let images: [APIImage]
    let owner: User
}
