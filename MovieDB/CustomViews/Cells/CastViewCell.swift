//
//  CastViewCell.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import UIKit

class CastViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "CastViewCell"
    
    var castDetailViewModel: CastDetailViewModel? {
        didSet {
            configure()
        }
    }
    
    private let castImageView: CacheImageView = {
        let imageView = CacheImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private let castInitialName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .systemBackground
        label.font = UIFont.boldSystemFont(ofSize: 70)
        label.isHidden = true
        return label
    }()
    
    private let castNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    
    private func configureView() {
        contentView.addSubview(castImageView)
        contentView.addSubview(castNameLabel)
        castImageView.addSubview(castInitialName)
        
        castImageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, paddingBottom: 10)
        castImageView.setHeightMultiflier(with: widthAnchor, multiflier: 1)
        castImageView.layer.cornerRadius = self.layer.frame.width / 2
        
        castNameLabel.anchor(top: castImageView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, paddingTop: 16)
        
        castInitialName.addConstraintsToFillView(castImageView)
        
    }
    
    private func configure() {
        guard let vm = castDetailViewModel else { return }
        
        castImageView.image = nil
        castImageView.downloadImage(from: vm.imageUrlString)
        castInitialName.isHidden = !vm.isProfilePathEmpty
        castInitialName.text = vm.initialName
        castNameLabel.text = vm.castName        
    }
}
