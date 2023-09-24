//
//  AuthError.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/24/23.
//

import Foundation

enum AuthError: Error {
    case urlError(url: String? = nil, message: String = "URL이 잘못되었습니다.")
    case refreshTokenIsNil(message: String = "Token 값이 nil을 반환합니다.")
    case shoudNotRefreshToken(message: String = "토큰 재요청이 필요하지 않습니다.")
}
