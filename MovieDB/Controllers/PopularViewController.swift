//
//  PopularViewController.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 01/06/21.
//

import UIKit

class PopularViewController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var popularViewModel = PopularListViewModel()
    
    private lazy var searchView: SearchView = {
        let sv = SearchView()
        sv.textField.placeholder = "Search"
        sv.searchButton.addTarget(self, action: #selector(didClickSearch), for: .touchUpInside)
        return sv
    }()
    
    //MARK: - Lifecycle

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
        collectionView.keyboardDismissMode = .onDrag
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        let statusBarView = UIView()
        statusBarView.frame = CGRect(x:0, y:0, width:view.frame.size.width, height: statusBarHeight)
        statusBarView.backgroundColor = .dbSecondaryBackground
        view.addSubview(statusBarView)
        
        view.addSubview(searchView)
        searchView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, height: 56)
    }
    
    private func configureCollectionView() {
        self.collectionView.backgroundColor = .dbBackground
        self.collectionView.contentInset = UIEdgeInsets(top: 76, left: 20, bottom: 20, right: 20)
        
        self.collectionView!.register(SearchHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderReusableView.identifier)
        self.collectionView!.register(PopularMovieViewCell.self, forCellWithReuseIdentifier: PopularMovieViewCell.identifier)
        self.collectionView!.register(FooterLoadingReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterLoadingReusableView.identifier)


    }
    
    private func fetchData() {
        popularViewModel.fetchMovie { (isSucces) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func searchMovie(_ query: String) {
        popularViewModel.searchMovie(query: query)
        searchView.searchButton.isEnabled = false
        self.collectionView.reloadData()
    }
    
    private func endSearchMovie() {
        popularViewModel.endSearchMovie()
        searchView.searchButton.isEnabled = false
        self.collectionView.reloadData()
    }

}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension PopularViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularViewModel.numberOfItemsInSection
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularMovieViewCell.identifier, for: indexPath) as! PopularMovieViewCell
        cell.viewModels = popularViewModel.movieViewModels[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderReusableView.identifier, for: indexPath) as! SearchHeaderReusableView
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterLoadingReusableView.identifier, for: indexPath) as! FooterLoadingReusableView
            footer.stopAnimating = popularViewModel.stopFooterAnimating()
        
            return footer
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = DetailViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // when user scroll to the end of data, call function to fetch next page data
        let minimumTrigger = scrollView.bounds.size.height + 10

        if scrollView.contentSize.height > minimumTrigger{

            let distanceFromBottom = scrollView.contentSize.height - (scrollView.bounds.size.height - scrollView.contentInset.bottom) - scrollView.contentOffset.y

            if distanceFromBottom < 10 && popularViewModel.isAllowedLoadMoreData() {
                fetchData()
            }
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension PopularViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2) - 28, height: 264)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 30)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 26)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        18
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        15
    }
    
}

//MARK: - UITextFieldDelegate

extension PopularViewController: UITextFieldDelegate {
    
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
