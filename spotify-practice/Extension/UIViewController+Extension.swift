//
//  UIViewController+Extension.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

import UIKit

extension UIViewController {
    
    func setNavigationBatTitle(title: String, titleColor: UIColor = .label, isLargeTitle: Bool = false) {
        self.navigationItem.title = title
        self.navigationController?.navigationBar.prefersLargeTitles = isLargeTitle
        self.navigationController?.navigationBar.titleTextAttributes  = [.foregroundColor: titleColor]
    }
    
    func push (_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
}
