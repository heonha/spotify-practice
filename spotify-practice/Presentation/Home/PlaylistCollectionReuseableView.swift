//
//  PlaylistCollectionReuseableView.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/3/23.
//

import UIKit
import SDWebImage

class PlaylistCollectionReuseableView: UICollectionReusableView, Reuseable {
    
    static var reuseId: String = "PlaylistCollectionReuseableView"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 2
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .secondaryLabel
        return label

    }()
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(imageView)
        
        // nameLabel.backgroundColor = .red
        // descriptionLabel.backgroundColor = .blue
        // ownerLabel.backgroundColor = .yellow
        // imageView.backgroundColor = .systemGreen
                
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(self.snp.width).dividedBy(1.8)
            make.top.equalTo(self).inset(20)
            make.centerX.equalTo(self)
        }
        
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(4)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(nameLabel)
        }
        
        ownerLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        ownerLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(nameLabel)
            make.bottom.equalToSuperview().inset(10)
        }

    }
    
    func configure(with viewModel: PlaylistHeaderViewModel) {
        self.nameLabel.text = viewModel.name
        self.descriptionLabel.text = viewModel.desctiption
        self.ownerLabel.text = viewModel.ownerName
        self.imageView.sd_setImage(with: viewModel.artworkURL)
    }
    
}
