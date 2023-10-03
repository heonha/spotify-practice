//
//  FeaturedPlaylistCollectionViewCell.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/2/23.
//

import UIKit
import SnapKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell, Reuseable {
    
    static var reuseId = "FeaturedPlaylistCollectionViewCell"
    
    private var albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.mic.circle")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private var albumNameLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private var artistNameLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 13, weight: .regular)
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
        
        contentView.backgroundColor = .systemBackground
        
        let imageSize = contentView.frame.width / 1.8
        
        albumCoverImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(8)
            make.size.equalTo(imageSize)
            make.centerX.equalTo(contentView)
        }
        
        albumNameLabel.snp.makeConstraints { make in
            make.top.equalTo(albumCoverImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(albumCoverImageView)
            make.centerX.equalTo(albumCoverImageView)
        }
        
        artistNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(albumNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(albumCoverImageView)
            make.centerX.equalTo(albumCoverImageView)
            make.bottom.equalTo(contentView).inset(8)
        }

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.albumNameLabel.text = "-"
        self.artistNameLabel.text = "-"
        self.albumCoverImageView.image = UIImage(systemName: "music.mic.circle")
    }
    
    func configure(with viewModel: FeaturedPlaylistViewModel) {
        self.albumNameLabel.text = viewModel.albumName
        self.artistNameLabel.text = viewModel.artistName
        self.albumCoverImageView.sd_setImage(with: viewModel.artworkImageURL)
    }
    
}
