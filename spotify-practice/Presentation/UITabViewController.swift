//
//  UITabViewController.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

import UIKit
import SnapKit

final class UITabViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        layout()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func configure() {
        self.view.backgroundColor = .systemBlue 
    }
    
    private func layout() {
        
    }
    
    private func bind() {
        
    }
    
}
