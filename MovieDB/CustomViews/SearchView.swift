//
//  SearchView.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import UIKit

class SearchView: UIView {
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.returnKeyType = .done
        return tf
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.tintColor = .dbYellow
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .dbSecondaryBackground
        addSubview(textField)
        addSubview(searchButton)
        
        searchButton.centerY(inView: self)
        searchButton.anchor(trailing: trailingAnchor, paddingRight: 40, width: 18, height: 18)
        
        textField.centerY(inView: searchButton)
        textField.anchor(leading: leadingAnchor, trailing: trailingAnchor, paddingLeft: 20, paddingRight: 58)
        
        let line = UIView()
        line.backgroundColor = .dbTertiaryBackground
        line.alpha = 0.12
        
        addSubview(line)
        line.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, paddingLeft: 20, paddingBottom: 8, paddingRight: 20, height: 0.86)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
