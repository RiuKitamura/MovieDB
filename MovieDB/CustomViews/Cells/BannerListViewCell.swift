//
//  BannerListViewCell.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 01/06/21.
//

import UIKit

protocol BannerListViewCellDelegate: class {
    func didClickCell(_ movieViewModel: MovieViewModel)
}
class BannerListViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "BannerListViewCell"

    var viewModels: [MovieViewModel]? {
        didSet {
            if viewModels != nil {
                self.collectionView.reloadData()
            }
        }
    }
    
    weak var delegate: BannerListViewCellDelegate?
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.backgroundColor = .clear
        return cv
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - Helpers
    
    private func configureCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: ImageViewCell.identifier)
        
        self.contentView.addSubview(collectionView)
        collectionView.addConstraintsToFillView(self.contentView)
        
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension BannerListViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vms = viewModels else {
            return 0
        }
        return vms.count > 3 ? 3 : vms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.identifier, for: indexPath) as! ImageViewCell
        if let vms = viewModels {
            cell.viewModel = vms[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: layer.frame.width, height: layer.frame.height - 0.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vm = viewModels?[indexPath.row] else { return }
        delegate?.didClickCell(vm)
    }

}
