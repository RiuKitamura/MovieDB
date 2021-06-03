//
//  HomeViewController.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 01/06/21.
//

import UIKit


class HomeViewController: UICollectionViewController {
    
    //MARK: - Properties
    private var homeViewModel = HomeListViewModel()
    
    //MARK: - Lifeycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCollectionView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Helpers
    
    private func configureView() {
        let navigationView = NavigationView()
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        let statusBarView = UIView()
        statusBarView.frame = CGRect(x:0, y:0, width:view.frame.size.width, height: statusBarHeight)
        statusBarView.backgroundColor = .dbSecondaryBackground
        view.addSubview(statusBarView)
        
        view.addSubview(navigationView)
        navigationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 56)
    }
    
    private func configureCollectionView() {
        
        self.collectionView.backgroundColor = .dbBackground
        self.collectionView.contentInset = UIEdgeInsets(top: 76, left: 0, bottom: 11, right: 0)
        self.collectionView.showsVerticalScrollIndicator = false
        // Register cell classes
        self.collectionView!.register(BannerListViewCell.self, forCellWithReuseIdentifier: BannerListViewCell.identifier)
        self.collectionView!.register(PopularMoviesListViewCell.self, forCellWithReuseIdentifier: PopularMoviesListViewCell.identifier)
        self.collectionView!.register(ComingSoonListViewCell.self, forCellWithReuseIdentifier: ComingSoonListViewCell.identifier)
    }
    
    private func fetchData() {
        homeViewModel.fetchMovie { (isSucces) in
            if isSucces {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

}

//MARK: - UICollectionViewDataSource

extension HomeViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.numberOfItemsInSection
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure the cell
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerListViewCell.identifier, for: indexPath) as! BannerListViewCell
            cell.viewModels = homeViewModel.bannerViewModels
            cell.delegate = self
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularMoviesListViewCell.identifier, for: indexPath) as! PopularMoviesListViewCell
            cell.viewModels = homeViewModel.popularMovieViewModels
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComingSoonListViewCell.identifier, for: indexPath) as! ComingSoonListViewCell
            cell.viewModels = homeViewModel.comingSoonViewModels
            cell.delegate = self
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
            return CGSize(width: width, height: height * 0.27)
        }
    }
}

//MARK: - BannerListViewCellDelegate

extension HomeViewController: BannerListViewCellDelegate, PopularMoviesListViewCellDelegate, ComingSoonListViewCellDelegate{
    func didClickCell(_ movieViewModel: MovieViewModel) {
        let controller = DetailViewController(movieId: movieViewModel.id)
        navigationController?.pushViewController(controller, animated: true)
    }
}
