//
//  FavoriteMovieViewCell.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import UIKit

protocol FavoriteMovieViewCellDelegate: class {
    func didClickHeartButton(_ cell: FavoriteMovieViewCell)
}

class FavoriteMovieViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "FavoriteMovieViewCell"
    
    var viewModel: FavoriteViewModel? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: FavoriteMovieViewCellDelegate?
    
    private let imageView: CacheImageView = {
        let iv = CacheImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var buttonHeart: UIButton = {
        let button = UIButton(type: .system)
        button.setDimensions(width: 24, height: 24)
        button.layer.cornerRadius = 12
        button.backgroundColor = .dbSecondaryYellow
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 4, bottom: 6, right: 5)
        button.tintColor = .dbYellow
        button.addTarget(self, action: #selector(didClickHeartButton), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, width: frame.width * 0.45)
        
        contentView.addSubview(buttonHeart)
        buttonHeart.anchor(top: contentView.topAnchor, trailing: contentView.trailingAnchor)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, yearLabel, genreLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .top
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        contentView.addSubview(stack)
        stack.anchor(top: contentView.topAnchor, leading: imageView.trailingAnchor, trailing: buttonHeart.leadingAnchor, paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc private func didClickHeartButton() {
        delegate?.didClickHeartButton(self)
    }
    
    //MARK: - Helpers
    
    private func configure() {
        guard let vm = viewModel else { return }
        imageView.downloadImage(from: vm.posterLink)
        titleLabel.text = vm.movieTitle
        yearLabel.text = vm.releaseYear
        genreLabel.text = vm.genre
    }
}
