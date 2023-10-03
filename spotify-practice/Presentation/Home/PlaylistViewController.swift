//
//  PlaylistViewController.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/3/23.
//

import UIKit
import SnapKit

final class PlaylistViewController: UIViewController {
    
    private var playlist: Playlist
    
    private var viewModels: [RecommendedTrackViewModel]?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            self.recommendedTracksSectionLayout()
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    init(playlist: Playlist) {
        self.playlist = playlist
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
        title = playlist.name
        view.backgroundColor = .systemBackground
        
        collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        APICaller.shared.getPlaylistDetails(for: playlist) { [weak self] result in
            switch result {
            case .success(let playlistDetail):
                print("✅ DEBUG: FETCHED Playlists : \(playlistDetail)")
                    
                self?.viewModels = playlistDetail.tracks.items?.compactMap { track in
                    return RecommendedTrackViewModel(name: track.track.name, artistName: track.track.artists.first?.name ?? "", artworkURL: track.track.album?.images.first?.url.toUrl())
                }
                
                self?.collectionView.reloadData()
            case .failure(let error):
                print("❗️ERROR: getPlaylistDetails : \(error)")
            }
        }
    }
    
    /// 3. 추천 트랙 레이아웃
    private func recommendedTracksSectionLayout() -> NSCollectionLayoutSection {
        let cellWidth: CGFloat = 60
        
        // Item
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(cellWidth))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
        
        // Group
        // FIXME: 16.0+ 에서 vertical (layoutSize:, subitem:, count:) deprecated 됨
        let verticalLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(cellWidth))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalLayoutSize,
                                                               subitem: item,
                                                               count: 1)
        
        // Section
        let section = NSCollectionLayoutSection(group: verticalGroup)
        return section
    }
    
    
    private func layout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func bind() {
        
    }
    
}


extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.reuseId, for: indexPath) as? RecommendedTrackCollectionViewCell else { return UICollectionViewCell() }
        guard let data = viewModels?[indexPath.row] else {return UICollectionViewCell()}
        cell.configure(with: data)
        return cell
    }
}
