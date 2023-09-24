//
//  HomeViewController.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/24/23.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    private func configure() {
        let titleBarItem = UIBarButtonItem(title: "안녕하세요")
        titleBarItem.tintColor = .label
        titleBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 20, weight: .bold)], for: .normal)
        self.navigationItem.leftBarButtonItem = titleBarItem

        let settingsSymbol = UIImage(systemName: "gearshape")
        let settingsItem = UIBarButtonItem(image: settingsSymbol, style: .plain, target: self, action: #selector(pushSettingsVC))
        settingsItem.tintColor = .label
        
        self.navigationItem.rightBarButtonItem = settingsItem

    }
    
    @objc private func pushSettingsVC() {
        let settingsVC = SettingsViewController()
        self.push(settingsVC)
    }
    
    private func layout() {
        
    }
    
}
