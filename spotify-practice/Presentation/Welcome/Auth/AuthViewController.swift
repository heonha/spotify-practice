//
//  AuthViewController.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

import UIKit
import SnapKit
import WebKit

final class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    public var completionHandler: ((Result<Void, Error>) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBatTitle(title: "스포티파이로 계속하기", titleColor: .white)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func configure() {
        webView.navigationDelegate = self
        webView.load(.init(url: AuthManager.shared.signInURL!))
    }
    
    private func layout() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        guard let code = URLComponents(string: url.absoluteString)?
            .queryItems?
            .first(where: { $0.name == "code"}) else { return }
        
        AuthManager.shared
            .getTokenFromCode(code: code.value ?? "") { [weak self] result in
                if let completionHandler = self?.completionHandler {
                    completionHandler(result)
                }
            }
    }
    
}
