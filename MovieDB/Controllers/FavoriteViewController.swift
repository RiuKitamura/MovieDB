//
//  FavoriteViewController.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 01/06/21.
//

import UIKit

class FavoriteViewController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var favoriteViewModel = FavoriteListViewModel()
    
    private lazy var searchView: SearchView = {
        let sv = SearchView()
        sv.textField.placeholder = "Search"
        sv.searchButton.addTarget(self, action: #selector(didClickSearch), for: .touchUpInside)
        return sv
    }()
    
    private let emptiStageLabel: UILabel = {
        let label = UILabel()
        label.text = "No Favorite Yet"
        return label
    }()

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCollectionView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Selectors
    
    @objc private func didClickSearch() {
        guard let query = searchView.textField.text else { return }
        searchMovie(query)
        searchView.textField.resignFirstResponder()
    }

    //MARK: - Helpers
    
    private func configureView() {
        
        searchView.textField.delegate = self
        collectionView.backgroundColor = .dbBackground
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        let statusBarView = UIView()
        statusBarView.frame = CGRect(x:0, y:0, width:view.frame.size.width, height: statusBarHeight)
        statusBarView.backgroundColor = .dbSecondaryBackground
        view.addSubview(statusBarView)
        
        view.addSubview(searchView)
        searchView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 56)
        
        self.collectionView.addSubview(emptiStageLabel)
        emptiStageLabel.center(inView: self.view)
    }
    
    private func configureCollectionView() {
        self.collectionView.contentInset = UIEdgeInsets(top: 76, left: 20, bottom: 20, right: 20)
        self.collectionView!.register(FavoriteMovieViewCell.self, forCellWithReuseIdentifier: FavoriteMovieViewCell.identifier)
    }
    
    private func fetchData() {
        favoriteViewModel.fetchData {[weak self] (isSuccess) in
            guard let self = self else { return}
            if isSuccess {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.updateEmptyStage()
                }
            }
        }
    }
    
    private func searchMovie(_ query: String) {
        favoriteViewModel.searchMovie(query: query)
        searchView.searchButton.isEnabled = false
        self.collectionView.reloadData()
    }
    
    private func endSearchMovie() {
        favoriteViewModel.endSearchMovie()
        searchView.searchButton.isEnabled = false
        self.collectionView.reloadData()
    }
    
    private func updateEmptyStage() {
        emptiStageLabel.isHidden = !favoriteViewModel.isDataEempty()
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension FavoriteViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteViewModel.favorites.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMovieViewCell.identifier, for: indexPath) as! FavoriteMovieViewCell
        cell.viewModel = favoriteViewModel.favorites[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieId = favoriteViewModel.favorites[indexPath.row].movieId else { return }
        let controller = DetailViewController(movieId: movieId)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: 89)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
}

//MARK: - UITextFieldDelegate

extension FavoriteViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchView.searchButton.isEnabled = true
        if textField.text == "" {
            endSearchMovie()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchView.searchButton.isEnabled = false
        searchView.textField.resignFirstResponder()
        guard let query = searchView.textField.text, query != "" else { return false }
        searchMovie(query)
        return true
    }
}

//MARK: - FavoriteMovieViewCellDelegate

extension FavoriteViewController: FavoriteMovieViewCellDelegate {
    func didClickHeartButton(_ cell: FavoriteMovieViewCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        guard let id = cell.viewModel?.movieId else { return }
        favoriteViewModel.deleteFavorite(id, at: indexPath.row) { (isSuccess) in
            if isSuccess {
                self.collectionView.deleteItems(at: [indexPath])
                self.updateEmptyStage()
            }
        }
    }

}
