//
//  String+Extension.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/2/23.
//

import Foundation

extension String {
    
    func toUrl() -> URL? {
        return URL(string: self)
    }
    
    
}
