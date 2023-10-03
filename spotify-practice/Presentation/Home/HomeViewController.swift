//
//  HomeViewController.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/24/23.
//

import UIKit
import SnapKit

enum BrowseSectionType {
    case newReleases(viewModel: [NewReleaseCellViewModel])
    case featuredPlaylists(viewModel: [FeaturedPlaylistViewModel])
    case recommendedTracks(viewModel: [RecommendedTrackViewModel])
}

final class HomeViewController: UIViewController {
    
    private var albums: [Album] = []
    private var playlists: [Playlist] = []
    private var tracks: [AudioTrack] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            self.createSectionLayout(section: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var sections = [BrowseSectionType]()
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        collectionViewConfigure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: - CollectionView
    private func collectionViewConfigure() {
        collectionView.register(NewReleaseCollectionViewCell.self, 
                                forCellWithReuseIdentifier: NewReleaseCollectionViewCell.reuseId)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, 
                                forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.reuseId)
        collectionView.register(RecommendedTrackCollectionViewCell.self, 
                                forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.reuseId)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
    }

    
    // MARK: - SuperView
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
    
    private func fetchData() {
        print("MSG: 데이터를 가져오기위해 준비합니다.")
        let group = DispatchGroup()
        group.enter()
        group.enter()
        // group.enter()

        // New Releases
        var newReleases: NewReleaseResponse?

        APICaller.shared.getNewReleases { result in
            print("MSG: getNewReleases를 받았습니다")
            defer {
                group.leave()
                print("group leave")
            }
            switch result {
            case .success(let data):
                newReleases = data
            case .failure(let error):
                print("ERROR: \(error.localizedDescription)")
            }
        }
        
        
        // Featured Playlists
        var featuredPlaylists: FeaturedPlaylistsResponse?

        APICaller.shared.getAllFeaturedPlaylists { result in
            print("MSG: getAllFeaturedPlaylists를 받았습니다")
            defer {
                group.leave()
                print("group leave")
            }
            switch result {
            case .success(let data):
                featuredPlaylists = data
            case .failure(let error):
                print("ERROR: \(error.localizedDescription)")
            }
        }
        
        var recommendations: RecommendationsResponse?
        // Recommended Tracks
        APICaller.shared.getAllRecommendationGenres { result in
            print("MSG: getAllRecommendationGenres를 받았습니다")
            switch result {
            case .success(let data):
                let genres = data.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                
                APICaller.shared.getAllRecommendations(genres: seeds) { recommendedResult in
                    print("MSG: getAllRecommendations를 받았습니다")
                    defer {
                        group.leave()
                    }
                    switch recommendedResult {
                    case .success(let data):
                        recommendations = data
                    case .failure(let error):
                        print("ERROR: \(error.localizedDescription)")
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) {
            print("group notify")
            guard let newAlbums = newReleases?.albums.items,
                  let playlists = featuredPlaylists?.playlists.items else {
                fatalError("API Data is nil")
            }
            
            print("MSG: Cell API를 불러왔습니다.")
            self.configureModels(albums: newAlbums,
                                 playlists: playlists,
                                 tracks: nil)
        }
    }
    
    private func configureModels(albums: [Album], playlists: [Playlist], tracks: [AudioTrack]?) {
        self.albums = albums
        self.playlists = playlists
        self.tracks = tracks ?? []
        
        
        let albumsViewModel = albums.compactMap { album in
            return NewReleaseCellViewModel.init(name: album.name, artworkURL: album.images.first?.url.toUrl(), numberOfTracks: album.totalTracks, artistName: album.artists.first?.name ?? "-")
        }
        
        let playlistViewModel = playlists.compactMap { playlist in
            return FeaturedPlaylistViewModel(albumName: playlist.name, artistName: playlist.owner.displayName, artworkImageURL: playlist.images.first?.url.toUrl())
        }
        
        
        let tracksViewModel = tracks?.compactMap { track in
            return RecommendedTrackViewModel(name: track.name, artistName: track.artists.first?.name ?? "", artworkURL: track.album?.images.first?.url.toUrl())
        }
        
        print("MSG: ViewModel을 셋업했습니다.")

        sections.append(.newReleases(viewModel: albumsViewModel))
        sections.append(.featuredPlaylists(viewModel: playlistViewModel))
        sections.append(.recommendedTracks(viewModel: tracksViewModel ?? []))
        print("MSG: 리로드를 시작합니다.")
        collectionView.reloadData()
    }
    
    @objc private func pushSettingsVC() {
        let settingsVC = SettingsViewController()
        self.push(settingsVC)
    }
    
    private func layout() {
        view.addSubview(collectionView)
        view.addSubview(spinner)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        spinner.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = self.sections[indexPath.section]
        switch section {
        case .newReleases:
            let data = albums[indexPath.row]
            let vc = AlbumViewController(album: data)
            self.navigationController?.pushViewController(vc, animated: true)
            break
            
        case .featuredPlaylists:
            let data = playlists[indexPath.row]
            let vc = PlaylistViewController(playlist: data)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .recommendedTracks:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .newReleases(viewModel: let viewModels):
            return viewModels.count
        case .featuredPlaylists(viewModel: let viewModels):
            return viewModels.count
        case .recommendedTracks(viewModel: let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        case .newReleases(viewModel: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.reuseId, 
                                                                for: indexPath) as? NewReleaseCollectionViewCell else { return UICollectionViewCell() }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .featuredPlaylists(viewModel: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.reuseId, for: indexPath) as? FeaturedPlaylistCollectionViewCell else { return UICollectionViewCell() }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell

        case .recommendedTracks(viewModel: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.reuseId, for: indexPath) as? RecommendedTrackCollectionViewCell else { return UICollectionViewCell() }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }
    
}

extension HomeViewController {
    // MARK: - CollectionView Layout

    private func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 0:
            return newReleasesSectionLayout()

        case 1:
            return featuredPlaylistsSectionLayout()

        case 2:
            return recommendedTracksSectionLayout()
            
        default:
            return defultSectionLayout()
        }
    }
    
    /// 1. 신곡 추천 레이아웃
    private func newReleasesSectionLayout() -> NSCollectionLayoutSection {
        // Item
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // Group
        // FIXME: 16.0+ 에서 vertical (layoutSize:, subitem:, count:) deprecated됨
        let verticalLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalLayoutSize,
                                                               subitem: item,
                                                               count: 3)
                
        let horizontalLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(390))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalLayoutSize,
                                                                 subitem: verticalGroup,
                                                                 count: 1)
        // Section
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    
    /// 2. 추천 플레이 리스트 레이아웃
    private func featuredPlaylistsSectionLayout() -> NSCollectionLayoutSection {
        let cellSize: CGFloat = 200
        let groupHeight: CGFloat = cellSize * 2
        
        // Item
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .absolute(cellSize), heightDimension: .absolute(cellSize))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // Group
        // FIXME: 16.0+ 에서 vertical (layoutSize:, subitem:, count:) deprecated됨
        let verticalLayoutSize = NSCollectionLayoutSize(widthDimension: .absolute(cellSize),
                                                        heightDimension: .absolute(groupHeight))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalLayoutSize,
                                                               subitem: item,
                                                               count: 2)
        
        let horizontalLayoutSize = NSCollectionLayoutSize(widthDimension: .absolute(cellSize),
                                                          heightDimension: .absolute(groupHeight))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalLayoutSize,
                                                                 subitem: verticalGroup,
                                                                 count: 1)
        // Section
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    
    /// 3. 추천 트랙 레이아웃
    private func recommendedTracksSectionLayout() -> NSCollectionLayoutSection {
        let cellWidth: CGFloat = 60
        
        // Item
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(cellWidth))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // Group
        // FIXME: 16.0+ 에서 vertical (layoutSize:, subitem:, count:) deprecated됨
        let verticalLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(cellWidth))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalLayoutSize,
                                                               subitem: item,
                                                               count: 1)
        
        // Section
        let section = NSCollectionLayoutSection(group: verticalGroup)
        return section
    }
    
    private func defultSectionLayout() -> NSCollectionLayoutSection {
        // Item
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // Group
        // FIXME: 16.0+ 에서 vertical (layoutSize:, subitem:, count:) deprecated됨
        let verticalLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(460))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalLayoutSize,
                                                               subitem: item,
                                                               count: 1)
                
        let horizontalLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(390))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalLayoutSize,
                                                                 subitem: verticalGroup,
                                                                 count: 1)
        // Section
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        return section
    }
    
    
    
}
