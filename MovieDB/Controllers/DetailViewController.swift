//
//  DetailViewController.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import UIKit
import SafariServices

class DetailViewController: UICollectionViewController {
    
    //MARK: - Properties
    
    private let detailListViewModel: DetailListViewModel
    
    private let loadSpinner = UIActivityIndicatorView()

    
    //MARK: - Init
    init(movieId: Int) {
        self.detailListViewModel = DetailListViewModel(movieId: movieId)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchMovieDetail()
    }
    
    //MARK: - Helpers
    
    private func configureCollectionView() {
        self.view.addSubview(loadSpinner)
        loadSpinner.center(inView: self.view)
        
        self.collectionView.backgroundColor = .dbBackground
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        self.collectionView!.register(MovieDetailHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieDetailHeaderReusableView.identifier)
        self.collectionView!.register(MovieOverviewViewCell.self, forCellWithReuseIdentifier: MovieOverviewViewCell.identifier)
        self.collectionView!.register(CastListViewCell.self, forCellWithReuseIdentifier: CastListViewCell.identifier)

    }
    
    private func fetchMovieDetail() {
        loadSpinner.startAnimating()
        detailListViewModel.fetchMovieDetail {[weak self] (isSuccess) in
            guard let self = self else { return }
            self.loadSpinner.stopAnimating()

            if isSuccess {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

}

//MARK: - UICollectionViewDataSource

extension DetailViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return detailListViewModel.numberOfOverviewItemsInSection
        } else {
            return detailListViewModel.numberOfCastItemsInSection
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieOverviewViewCell.identifier, for: indexPath) as! MovieOverviewViewCell
            cell.movieDetailViewModel = detailListViewModel.movieDetailViewModel
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastListViewCell.identifier, for: indexPath) as! CastListViewCell
            cell.viewModel = detailListViewModel.movieDetailViewModel?.getAllCastViewModel()
            return cell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieDetailHeaderReusableView.identifier, for: indexPath) as! MovieDetailHeaderReusableView
        header.movieDetailViewModel = detailListViewModel.movieDetailViewModel
        header.delegate = self
        return header
    }
    
}

//MARK: - UICollectionViewDelegate

extension DetailViewController {
    
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
            
            guard let overviewStrig = detailListViewModel.movieDetailViewModel?.overview else {
                return .zero
            }
            let estimateFrame = NSString(string: overviewStrig).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: atribute, context: nil)
            return CGSize(width: view.frame.width, height: estimateFrame.height + 10 + 56)
        }
        
        return CGSize(width: view.frame.width, height: 222)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 && !detailListViewModel.shuldHideHeader(){
            return CGSize(width: view.frame.width, height: view.frame.height * 0.7)
        }
        
        return .zero
    }
}

//MARK: - MovieDetailHeaderReusableViewDelegate

extension DetailViewController: MovieDetailHeaderReusableViewDelegate {
    func didClickAddFavorite(_ movie: MovieDetailViewModel) {
        
        if movie.didFavorite {
            detailListViewModel.deleteFavorite(movie.movieDetailData) { (isSuccess) in
                if isSuccess {
                    self.collectionView.reloadData()
                }
            }
            
        } else {
            detailListViewModel.addToFavorite(movie.movieDetailData) { (isSuccess) in
                if isSuccess {
                    self.collectionView.reloadData()
                }
            }
        }
        
    }
    
    func didClickTriler(_ url: URL) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true)
    }
    
}
