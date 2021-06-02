//
//  NavigationView.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import UIKit

class NavigationView: UIView {
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "Logo")
        return iv
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .white
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .dbSecondaryBackground
        addSubview(logoImageView)
        logoImageView.centerY(inView: self, leadingAnchor: leadingAnchor, paddingLeft: 20)
        logoImageView.setDimensions(width: 121, height: 35)
        
        addSubview(button)
        button.centerY(inView: self)
        button.anchor(trailing: trailingAnchor, paddingRight: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
