//
//  ComingSoonListViewCell.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 01/06/21.
//

import UIKit

protocol ComingSoonListViewCellDelegate: class {
    func didClickCell(_ movieViewModel: MovieViewModel)
}

class ComingSoonListViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "ComingSoonListViewCell"
    
    var viewModels: [MovieViewModel]? {
        didSet {
            if viewModels != nil {
                self.collectionView.reloadData()
            }
        }
    }
    
    weak var delegate: ComingSoonListViewCellDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Coming Soon"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        cv.backgroundColor = .clear
        return cv
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureView() {
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, paddingTop: 30, paddingLeft: 20)
        
        contentView.addSubview(collectionView)
        
        collectionView.anchor(top: titleLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, paddingTop: 13)
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: ImageViewCell.identifier)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ComingSoonListViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vms = viewModels else {
            return 0
        }
        return vms.count > 10 ? 10 : vms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.identifier, for: indexPath) as! ImageViewCell
        if let vms = viewModels {
            cell.viewModel = vms[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: layer.frame.width / 3.7, height: layer.frame.height - 63)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModels?[indexPath.row] else { return }
        delegate?.didClickCell(viewModel)
    }
    
}
