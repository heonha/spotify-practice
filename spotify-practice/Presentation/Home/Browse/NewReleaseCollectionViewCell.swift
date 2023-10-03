//
//  NewReleaseCollectionViewCell.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/2/23.
//

import UIKit
import SnapKit

class NewReleaseCollectionViewCell: UICollectionViewCell, Reuseable {

    static var reuseId = "NewReleaseCollectionViewCell"
    
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
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private var numberOfTracksLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .light)
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
        contentView.addSubview(numberOfTracksLabel)
        
        contentView.backgroundColor = .secondarySystemBackground
        
        albumCoverImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(contentView).inset(4)
            make.width.equalTo(contentView.snp.height).inset(10)
        }
        
        albumNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumCoverImageView.snp.trailing).offset(12)
            make.top.trailing.equalTo(contentView).inset(8)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(albumNameLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(albumNameLabel)
        }
        
        numberOfTracksLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(albumNameLabel)
            make.bottom.equalTo(contentView).inset(10)
        }

        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.albumNameLabel.text = "-"
        self.artistNameLabel.text = "-"
        self.numberOfTracksLabel.text = "-"
        self.albumCoverImageView.image = UIImage(systemName: "music.mic.circle")
    }
    
    func configure(with viewModel: NewReleaseCellViewModel) {
        self.albumNameLabel.text = viewModel.name
        self.artistNameLabel.text = viewModel.artistName
        self.numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks.description)"
        self.albumCoverImageView.sd_setImage(with: viewModel.artworkURL)
    }
    
}
