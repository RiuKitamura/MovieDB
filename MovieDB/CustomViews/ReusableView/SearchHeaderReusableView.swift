//
//  SearchHeaderReusableView.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import UIKit

class SearchHeaderReusableView: UICollectionReusableView {
    
    //MARK: - Properties
    static let identifier = "SearchHeaderReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Showing result of "
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let labelSearch: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [label, labelSearch])
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fill
        stack.alignment = .leading
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        addSubview(stack)
        stack.addConstraintsToFillView(self)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(message: String, query: String) {
        label.text = message
        labelSearch.text = "'\(query)'"
    }
}
