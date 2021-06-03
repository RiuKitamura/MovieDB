//
//  FooterLoadingReusableView.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 03/06/21.
//

import UIKit

class FooterLoadingReusableView: UICollectionReusableView {
    
    static let identifier = "FooterLoadingReusableView"
    
    var stopAnimating: Bool? {
        didSet {
            configure()
        }
    }
    
    private let footerLoadSpinner = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(footerLoadSpinner)
        footerLoadSpinner.center(inView: self)
        footerLoadSpinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        guard let stop = stopAnimating else { return }
        if stop {
            footerLoadSpinner.stopAnimating()
        } else {
            footerLoadSpinner.startAnimating()
        }
    }
}
