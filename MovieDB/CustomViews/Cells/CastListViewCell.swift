//
//  CastListViewCell.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import UIKit

class CastListViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "CastListViewCell"
    
    var viewModel: [CastDetailViewModel]? {
        didSet {
            if let vm = viewModel {
                castDetailViewModels = vm
                self.collectionView.reloadData()
            }
            
        }
    }
    private var castDetailViewModels = [CastDetailViewModel]()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Cast"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        confitureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureView() {
        
        collectionView.backgroundColor = .clear
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, paddingLeft: 20)
        
        contentView.addSubview(collectionView)
        
        collectionView.anchor(top: titleLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, paddingTop: 24)
    }
    
    private func confitureCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CastViewCell.self, forCellWithReuseIdentifier: CastViewCell.identifier)
    
    }
}

//MARK: - UICollectionView Delegate

extension CastListViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if castDetailViewModels.count > 10 {
            return 10
        }
        
        return castDetailViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastViewCell.identifier, for: indexPath) as! CastViewCell
        cell.castDetailViewModel = castDetailViewModels[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: layer.frame.width / 4, height: layer.frame.height - 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}
