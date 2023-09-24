//
//  UITabViewController.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

import UIKit
import SnapKit

final class UITabViewController: UITabBarController {
    
    private let profileVC = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func configure() {
        self.view.backgroundColor = .systemBackground
        let profileNC = UINavigationController(rootViewController: profileVC)
        let profileItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "person.fill"), tag: 0)
        profileNC.tabBarItem = profileItem
        self.viewControllers = [profileNC]
    }
    
}
