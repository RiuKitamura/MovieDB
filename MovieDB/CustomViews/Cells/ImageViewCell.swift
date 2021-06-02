//
//  ImageViewCell.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 01/06/21.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "ImageViewCell"
    
    var viewModel: MovieViewModel? {
        didSet {
            configure()
        }
    }
    
    private let imageView: CacheImageView = {
        let iv = CacheImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        return iv
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configure() {
        guard let vm = viewModel else { return }
        imageView.downloadImage(from: vm.posterLink)
    }
}
