//
//  AlbumDetailResponse.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/3/23.
//

import Foundation

struct AlbumDetailResponse: Codable {
    let albumType: String
    let artists: [Artist]
    let avaliableMarkets: [String]?
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: TracksResponse
    
    private enum CodingKeys: String, CodingKey {
        case artists, id, images, label, name, tracks
        case albumType = "album_type"
        case avaliableMarkets = "available_markets"
    }
}
