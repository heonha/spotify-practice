//
//  AlbumViewController.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/3/23.
//

import UIKit
import SnapKit

final class AlbumViewController: UIViewController {

    private let album: Album
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    private func configure() {
        title = album.name
        view.backgroundColor = .systemBackground
        
        APICaller.shared.getAlbumDetails(for: album) { result in
            switch result {
            case .success(let albumDetail):
                print("✅ DEBUG: FETCHED ALBUMDETAIL : \(albumDetail)")
            case .failure(let error):
                print("❗️ERROR: getAlbumDetails : \(error)")
            }
        }
    }
    
    private func layout() {
        
    }
    
    private func bind() {
        
    }
    
}
