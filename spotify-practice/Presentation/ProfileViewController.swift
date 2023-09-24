//
//  ProfileViewController.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/24/23.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel = ProfileViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = .systemBackground
        self.setNavigationBatTitle(title: "Profile", isLargeTitle: true)
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProfile()
    }
    
    private func configure() {
        
    }
    
    private func layout() {
        
    }

    
}
