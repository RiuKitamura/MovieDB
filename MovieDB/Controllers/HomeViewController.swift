//
//  HomeViewController.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 01/06/21.
//

import UIKit


class HomeViewController: UICollectionViewController {
    
    //MARK: - Lifeycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
    }
    
    //MARK: - Helpers
    
    private func configureNavigationBar() {
        let logo = UIImage(named: "Logo")
        let imageView = UIImageView(image: logo)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: imageView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: nil, action: nil)
    }
    
    private func configureCollectionView() {
        
        self.collectionView.backgroundColor = .dbBackground
        self.collectionView.contentInset = UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 0)
        self.collectionView.showsVerticalScrollIndicator = false
        // Register cell classes
        self.collectionView!.register(BannerListViewCell.self, forCellWithReuseIdentifier: BannerListViewCell.identifier)
        self.collectionView!.register(PopularMoviesListViewCell.self, forCellWithReuseIdentifier: PopularMoviesListViewCell.identifier)
        self.collectionView!.register(ComingSoonListViewCell.self, forCellWithReuseIdentifier: ComingSoonListViewCell.identifier)
    }


    

}

//MARK: - UICollectionViewDataSource

extension HomeViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure the cell
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerListViewCell.identifier, for: indexPath) as! BannerListViewCell
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularMoviesListViewCell.identifier, for: indexPath) as! PopularMoviesListViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComingSoonListViewCell.identifier, for: indexPath) as! ComingSoonListViewCell
            return cell
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let height = view.frame.height
        
        if indexPath.section == 0 {
            return CGSize(width: width, height: height * 0.35)
        } else {
            return CGSize(width: width, height: height * 0.25)
        }
    }
}
