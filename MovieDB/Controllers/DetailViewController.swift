//
//  DetailViewController.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import UIKit

class DetailViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()

    }
    
    //MARK: - Helpers
    
    private func configureCollectionView() {
        self.collectionView.backgroundColor = .dbBackground
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        self.collectionView!.register(MovieDetailHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieDetailHeaderReusableView.identifier)
        self.collectionView!.register(MovieOverviewViewCell.self, forCellWithReuseIdentifier: MovieOverviewViewCell.identifier)
        self.collectionView!.register(CastListViewCell.self, forCellWithReuseIdentifier: CastListViewCell.identifier)

    }

}

//MARK: - UICollectionViewDataSource

extension DetailViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieOverviewViewCell.identifier, for: indexPath) as! MovieOverviewViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastListViewCell.identifier, for: indexPath) as! CastListViewCell
            return cell
        }
        
    }
    
}

//MARK: - UICollectionViewDelegate

extension DetailViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieDetailHeaderReusableView.identifier, for: indexPath) as! MovieDetailHeaderReusableView
        return header
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0)) as? MovieDetailHeaderReusableView else { return }
        header.scrollViewDidScroll(scrollView: collectionView)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.section == 0 {
            
            let approximateWidth = view.frame.width - 40
            let size = CGSize(width: approximateWidth, height: 1000)
            let atribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
            
            let estimateFrame = NSString(string: "Add constraints in that .xib that allow for the cell to be calculated from top to bottom. The re-sizing won't work if you haven't accounted for all of the height. Say you have a view on top, then a label underneath it, and another label underneath that. You would need to connect constraints to the top of the cell to the top of that view, then the bottom of the view to the top of the first label, bottom of first label to the top of the second label, and bottom of second label to bottom of cell. Add constraints in that .xib that allow for the cell to be calculated from top to bottom. The re-sizing won't work if you haven't accounted for all of the height. Say you have a view on top, then a label underneath it, and another label underneath that. You would need to connect constraints to the top of the cell to the top of that view, then the bottom of the view to the top of the first label, bottom of first label to the top of the second label, and bottom of second label to bottom of cell.").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: atribute, context: nil)
            return CGSize(width: view.frame.width, height: estimateFrame.height + 10 + 56)
        }
        
        return CGSize(width: view.frame.width, height: 222)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: view.frame.width, height: view.frame.height * 0.7)
        }
        
        return .zero
    }
}
