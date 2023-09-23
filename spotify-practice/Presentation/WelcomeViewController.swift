//
//  WelcomeViewController.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

import UIKit
import SnapKit

final class WelcomeViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
    }
    
    private func configure() {
        self.view.backgroundColor = .systemGreen
        self.navigationItem.title = "Spotify"
    }
    
    private func layout() {
        
    }
    
    private func bind() {
        
    }
    
}
