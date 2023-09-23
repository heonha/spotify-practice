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
    
    public var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        layout()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    private func configure() {
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.load(.init(url: AuthManager.shared.signInURL!))
    }
    
    private func layout() {
        
    }
    
    private func bind() {
        
    }
    
}
