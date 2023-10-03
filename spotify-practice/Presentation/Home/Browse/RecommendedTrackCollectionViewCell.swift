//
//  RecommendedTrackCollectionViewCell.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/2/23.
//

import UIKit
import SnapKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell, Reuseable {
    
    static var reuseId = "RecommendedTrackCollectionViewCell"
 
    private var albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.mic.circle")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var albumNameLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private var artistNameLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        
        contentView.backgroundColor = .secondarySystemBackground
        
        albumCoverImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(contentView)
            make.width.equalTo(contentView.snp.height)
        }
        
        albumNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumCoverImageView.snp.trailing).offset(12)
            make.top.trailing.equalTo(contentView).inset(8)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(albumNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(albumNameLabel)
            make.bottom.equalTo(contentView).inset(8)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.albumNameLabel.text = "-"
        self.artistNameLabel.text = "-"
        self.albumCoverImageView.image = UIImage(systemName: "music.mic.circle")
    }
    
    func configure(with viewModel: RecommendedTrackViewModel) {
        self.albumNameLabel.text = viewModel.name
        self.artistNameLabel.text = viewModel.artistName
        self.albumCoverImageView.sd_setImage(with: viewModel.artworkURL)
    }
    
}
