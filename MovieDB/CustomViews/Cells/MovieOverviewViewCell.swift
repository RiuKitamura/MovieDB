//
//  MovieOverviewViewCell.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import UIKit

class MovieOverviewViewCell: UICollectionViewCell {
    
    static let identifier = "MovieOverviewViewCell"
    
    var movieDetailViewModel: MovieDetailViewModel? {
        didSet {
            configure()
        }
    }
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(overviewLabel)
        overviewLabel.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, paddingTop: 24, paddingLeft: 20, paddingBottom: 32, paddingRight: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        guard let vm = movieDetailViewModel else { return }
        overviewLabel.text = vm.overview
    }

}
