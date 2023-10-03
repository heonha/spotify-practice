//
//  UITabViewController.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

import UIKit
import SnapKit

final class UITabViewController: UITabBarController {
    
    private let homeVC = HomeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func configure() {
        self.view.backgroundColor = .systemBackground
        
        self.tabBar.tintColor = .label
        
        let homeNC = BaseNavigationController(rootViewController: homeVC)
        let homeItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        homeNC.tabBarItem = homeItem
        self.viewControllers = [homeNC]
    }
    
}
