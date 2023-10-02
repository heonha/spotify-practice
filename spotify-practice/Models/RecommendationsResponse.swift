//
//  RecommendationsResponse.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/2/23.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}
