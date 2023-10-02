//
//  HomeViewController.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/24/23.
//

import UIKit
import SnapKit

enum BrowseSectionType {
    case newReleases
    case featuredPlaylists
    case recommendedTracks
}


final class HomeViewController: UIViewController {
    
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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
    }
    
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
        let cellWidth: CGFloat = 80
        
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
        APICaller.shared.getAllRecommendationGenres { result in
            switch result {
            case .success(let data):
                let genres = data.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                
                APICaller.shared.getAllRecommendations(genres: seeds) { result in
                    switch result {
                    case .success(let data):
                        print(data)
                    case .failure(let error):
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.backgroundColor = .systemGreen
        }
        
        if indexPath.section == 1 {
            cell.backgroundColor = .systemBlue
        }

        if indexPath.section == 2 {
            cell.backgroundColor = .systemPink
        }
        
        return cell
    }
    
}
