//
//  FavoriteViewController.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 01/06/21.
//

import UIKit

class FavoriteViewController: UICollectionViewController {
    
    //MARK: - Properties
    
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
        print(searchView.textField.text)
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
    }
    
    private func configureCollectionView() {
        self.collectionView.contentInset = UIEdgeInsets(top: 76, left: 20, bottom: 20, right: 20)
        self.collectionView!.register(FavoriteMovieViewCell.self, forCellWithReuseIdentifier: FavoriteMovieViewCell.identifier)
    }


}

//MARK: - UICollectionViewDataSource

extension FavoriteViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMovieViewCell.identifier, for: indexPath) as! FavoriteMovieViewCell
        
        return cell
    }
}

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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchView.textField.resignFirstResponder()
    }
}
