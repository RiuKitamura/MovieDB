//
//  MovieDetailHeaderReusableView.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import UIKit

protocol MovieDetailHeaderReusableViewDelegate: class {
    func didClickTriler(_ url: URL)
}
class MovieDetailHeaderReusableView: UICollectionReusableView {
    
    //MARK: - Properties
    
    static let identifier = "MoveDetailHeaderReusableView"
    
    var movieDetailViewModel: MovieDetailViewModel? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: MovieDetailHeaderReusableViewDelegate?
    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerViewHeight = NSLayoutConstraint()
    private var infoContainerView = UIView()
    
    private let coverImageView: CacheImageView = {
        let iv = CacheImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var watchTrailerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .dbYellow
        button.tintColor = .black
        button.setTitle("Watch Triler", for: .normal)
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.layer.cornerRadius = 4
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 13)
        button.addTarget(self, action: #selector(didClickWatchTrailer), for: .touchUpInside)
        return button
    }()
    
    private lazy var addFavoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.tintColor = .dbYellow
        button.setTitle("Add to Favorite", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 13)
        button.addTarget(self, action: #selector(didClickAddFavorite), for: .touchUpInside)
        return button
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        infoContainerView.addGradient(startColor: .clear, endColor: .dbBackground)
    }
    
    //MARK: - Selectors
    @objc private func didClickWatchTrailer() {
        guard let url = movieDetailViewModel?.trailerUrl() else { return }
        delegate?.didClickTriler(url)
    }
    
    @objc private func didClickAddFavorite() {
        print("fav")
    }
    
    //MARK: - Helpers
    
    private func configureView() {
        addSubview(infoContainerView)
        infoContainerView.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        let buttonStack = UIStackView(arrangedSubviews: [watchTrailerButton, addFavoriteButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 14
        buttonStack.distribution = .fillEqually
        
        watchTrailerButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        infoContainerView.addSubview(buttonStack)
        buttonStack.anchor(leading: infoContainerView.leadingAnchor, bottom: infoContainerView.bottomAnchor, trailing: infoContainerView.trailingAnchor, paddingLeft: 20, paddingRight: 20)
        
        infoContainerView.addSubview(genreLabel)
        genreLabel.anchor(leading: buttonStack.leadingAnchor, bottom: buttonStack.topAnchor, trailing: buttonStack.trailingAnchor, paddingBottom: 24)
        
        infoContainerView.addSubview(releaseDateLabel)
        releaseDateLabel.anchor(leading: buttonStack.leadingAnchor, bottom: genreLabel.topAnchor, trailing: buttonStack.trailingAnchor, paddingBottom: 14)
        
        infoContainerView.addSubview(titleLabel)
        titleLabel.anchor(top: infoContainerView.topAnchor, leading: buttonStack.leadingAnchor, bottom: releaseDateLabel.topAnchor, trailing: buttonStack.trailingAnchor, paddingTop: 175, paddingBottom: 9)
    }
    
    private func configureImageView() {
        addSubview(containerView)
        containerView.addSubview(coverImageView)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(equalTo: coverImageView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = coverImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = coverImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
    
    private func configure() {
        guard let vm = movieDetailViewModel else { return }
        titleLabel.text = vm.movieTitle
        genreLabel.attributedText = vm.genres
        coverImageView.downloadImage(from: vm.posterLink)
        releaseDateLabel.text = vm.releaseDate
    }
}
