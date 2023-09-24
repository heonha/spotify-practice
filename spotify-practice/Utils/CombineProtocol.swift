//
//  CombineProtocol.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/24/23.
//

import Combine

protocol CombineProtocol {
    var cancellables: Set<AnyCancellable> { get set }
}
