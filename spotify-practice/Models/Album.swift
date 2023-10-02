//
//  Album.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/2/23.
//

import Foundation

struct Album: Codable {
    let albumType: String
    let avaliableMarkets: [String]?
    let id: String
    let images: [APIImage]
    let name: String
    let releaseDate: String
    let totalTracks: Int
    let artists: [Artist]
    
    private enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case avaliableMarkets = "available_markets"
        case releaseDate = "release_date"
        case totalTracks = "total_tracks"
        case id, images, name, artists
    }
}
