//
//  WelcomeViewController.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

import UIKit
import SnapKit

final class WelcomeViewController: UIViewController {

    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Spotify로 시작하기", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        layout()
        bind()
    }
    
    private func configure() {
        self.view.backgroundColor = .systemGreen
        self.navigationItem.title = "Spotify"
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    private func layout() {
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
    }
    
    private func bind() {
        
    }
    
    @objc private func signInButtonTapped() {
        let authVC = AuthViewController()
        authVC.completionHandler = { [weak self] success in
            self?.handleSignIn(success: success)
        }
        authVC.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.pushViewController(authVC, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        
    }
    
}

#if DEBUG
import SwiftUI

struct WelcomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            UINavigationController(rootViewController: WelcomeViewController())
        }
        .ignoresSafeArea()
    }
}
#endif

