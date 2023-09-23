//
//  RestProtocol.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

import Foundation
import Combine

protocol RestProtocol {
    
    func GET<T: Codable>(headerType: HttpHeader,
                         urlString: String,
                         endPoint: String,
                         parameters: [String: String],
                         returnType: T.Type) -> Future<T, Error>
    
    func POST<T: Codable>(headerType: HttpHeader,
                          urlString: String,
                          endPoint: String,
                          body: [String: String],
                          returnType: T.Type) -> Future<T, Error>
    
}
