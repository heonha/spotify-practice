//
//  RestProtocol.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

import Foundation
import Combine

protocol RestProtocol {
    
    func request<T: Decodable>(
        method: HttpMethod,
        headerType: HttpHeader,
        urlString baseUrl: String,
        endPoint: String,
        parameters: [String: String],
        returnType: T.Type) -> Future<T, Error>
    
}
