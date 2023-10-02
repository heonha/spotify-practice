//
//  AudioTrack.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/2/23.
//

import Foundation

struct AudioTrack: Codable {
    let album: Album
    let artists: [Artist]
    let availableMarkets: [String]
    let discNumber: Int
    let durationMs: Int
    let explicit: Bool
    let externalUrls: [String: String]
    let id: String
    let name: String
    let popularity: Int
    
    private enum CodingKeys: String, CodingKey {
        case album, artists, explicit, id, name, popularity
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case externalUrls = "external_urls"
    }
}
