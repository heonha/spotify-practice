//
//  PlaylistDetailResponse.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/3/23.
//

import Foundation

struct PlaylistDetailResponse: Codable {
    let description: String
    let externalUrls: [String : String]
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlaylistTracksResponse
    
    private enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case description, id, images, name, tracks
    }
}
