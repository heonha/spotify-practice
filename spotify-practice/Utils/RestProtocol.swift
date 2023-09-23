//
//  RestProtocol.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

import Foundation

import Foundation
import Combine

protocol RestProtocol {
    
    func GET<T: Codable>(headerType: HeaderType,
                         urlString: String,
                         endPoint: String,
                         parameters: [String: String],
                         returnType: T.Type) -> Future<T, Error>
    
    func POST<T: Codable>(headerType: HeaderType,
                          urlString: String,
                          endPoint: String,
                          body: [String: String],
                          returnType: T.Type) -> Future<T, Error>
    
}

enum HeaderType {
    
    case applicationJson
    /// application/x-www-form-urlencoded
    case applicationxwwwformurlencoded
    case basicTokenHeader(clientId: String, clientSecret: String)
    
    func getHeader() -> [String: String] {
        switch self {
        case .applicationJson:
            return  ["Content-Type": "application/json"]
        case .applicationxwwwformurlencoded:
            return  ["Content-Type": "application/x-www-form-urlencoded"]
        case .basicTokenHeader(let clientId, let clientSecret):
            let token = clientId + ":" + clientSecret
            let encodedToken = token.data(using: .utf8)?.base64EncodedString() ?? ""
            
            return [
                "Content-Type": "application/x-www-form-urlencoded",
                "Authorization": "Basic \(encodedToken)",
            ]
        }
    }
    
}

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}
