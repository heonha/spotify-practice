//
//  APICallerError.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/2/23.
//

import Foundation

enum APICallerError: Error {
    case invalidToken(message: String = "")
}
