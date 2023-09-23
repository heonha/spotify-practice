//
//  UIViewControllerPreview.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    
    let viewController: ViewController
    
    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }
    
    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> ViewController {
        viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        
    }
}
#endif
