//
//  PlaylistCollectionReuseableView.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 10/3/23.
//

import UIKit
import SDWebImage

protocol PlaylistCollectionReuseableViewDelegate: AnyObject {
    func playlistCollectionReuseableViewDidTapPlayAll(_ header: PlaylistCollectionReuseableView)
}

class PlaylistCollectionReuseableView: UICollectionReusableView, Reuseable {
    
    static var reuseId: String = "PlaylistCollectionReuseableView"
    
    weak var delegate: PlaylistCollectionReuseableViewDelegate?
    
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
    
    private lazy var vstack: UIStackView = {
       let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.alignment = .top
        sv.spacing = 8

        sv.addArrangedSubview(nameLabel)
        sv.addArrangedSubview(descriptionLabel)
        sv.addArrangedSubview(ownerLabel)
        sv.addArrangedSubview(UIView())

        return sv
    }()
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        self.playAllButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        addSubview(imageView)
        addSubview(vstack)
        addSubview(playAllButton)
        
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(self.snp.width).dividedBy(1.8)
            make.top.equalTo(self).inset(20)
            make.centerX.equalTo(self)
        }
        
        vstack.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(4)
        }
        
        playAllButton.snp.makeConstraints { make in
            make.trailing.equalTo(self).inset(20)
            make.bottom.equalToSuperview().inset(10)
            make.size.equalTo(50)
        }

    }
    
    func configure(with viewModel: PlaylistHeaderViewModel) {
        self.nameLabel.text = viewModel.name
        self.descriptionLabel.text = viewModel.desctiption
        self.ownerLabel.text = viewModel.ownerName
        self.imageView.sd_setImage(with: viewModel.artworkURL)
    }
    
    @objc private func playButtonPressed() {
        print("PlayButton Tapped!")
        delegate?.playlistCollectionReuseableViewDidTapPlayAll(self)
    }
    
}
