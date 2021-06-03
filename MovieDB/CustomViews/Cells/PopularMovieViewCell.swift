//
//  PopularMovieViewCell.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import UIKit

class PopularMovieViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var viewModels: MovieViewModel? {
        didSet {
            configure()
        }
    }
    
    static let identifier = "PopularMovieViewCell"
    
    private let imageView: CacheImageView = {
        let iv = CacheImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        iv.layer.cornerRadius = 4
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        
        contentView.addSubview(imageView)
        imageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, height: 214)
        
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: imageView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, paddingTop: 8)
        
        contentView.addSubview(releaseDateLabel)
        releaseDateLabel.anchor(top: titleLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, paddingTop: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configure() {
        guard let vm = viewModels else { return }
        
        imageView.downloadImage(from: vm.posterLink)
        titleLabel.text = vm.title
        releaseDateLabel.text = vm.releaseDate
    }
    
}
