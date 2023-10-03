//
//  PlaylistTracksResponse.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/3/23.
//

import Foundation

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItemResponse]?
}
