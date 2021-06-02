//
//  MovieOverviewViewCell.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import UIKit

class MovieOverviewViewCell: UICollectionViewCell {
    
    static let identifier = "MovieOverviewViewCell"
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "Add constraints in that .xib that allow for the cell to be calculated from top to bottom. The re-sizing won't work if you haven't accounted for all of the height. Say you have a view on top, then a label underneath it, and another label underneath that. You would need to connect constraints to the top of the cell to the top of that view, then the bottom of the view to the top of the first label, bottom of first label to the top of the second label, and bottom of second label to bottom of cell. Add constraints in that .xib that allow for the cell to be calculated from top to bottom. The re-sizing won't work if you haven't accounted for all of the height. Say you have a view on top, then a label underneath it, and another label underneath that. You would need to connect constraints to the top of the cell to the top of that view, then the bottom of the view to the top of the first label, bottom of first label to the top of the second label, and bottom of second label to bottom of cell."
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

}
