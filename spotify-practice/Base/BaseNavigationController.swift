//
//  BaseNavigationController.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/3/23.
//

import UIKit
import SnapKit

class BaseNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.navigationBar.tintColor = .label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
