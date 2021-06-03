//
//  PopularListViewModel.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 03/06/21.
//

import Foundation

class PopularListViewModel {
    
    private(set) var movieViewModels = [MovieViewModel]()
    private var copyViewModels = [MovieViewModel]()
    private var nextPage = 1
    private var totalPages = 0
    private var isLoading = false
    private(set) var isSearchMode = false
    private(set) var query = ""
    
    func fetchMovie(completion: @escaping(Bool) -> Void) {
        
        updateLoadingStatus()
        
        guard let movieUrl = Constan.Url.urlForMovie(page: nextPage) else {
            completion(false)
            return
        }
        
        let movieResouce = Resource<Movie>(url: movieUrl) { (data) -> Movie? in
            let movie = try? JSONDecoder().decode(Movie.self, from: data)
            return movie
        }
        
        WebService().loadMovie(resource: movieResouce) {[weak self] (result) in
            guard let self = self else { return }

            self.updateLoadingStatus()

            switch result {
            case .success(let movie):
                guard let movie = movie else {
                    completion(false)
                    return
                }
                self.totalPages = movie.total_pages
                let vm = movie.results.map{MovieViewModel($0, isBaner: false)}
                self.movieViewModels.append(contentsOf: vm)
                self.copyViewModels = self.movieViewModels
                self.updateNextPage()
                
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func searchMovie(query: String) {
        isSearchMode = true
        self.query = query
        movieViewModels = copyViewModels
        movieViewModels = movieViewModels.filter{ $0.title.lowercased().contains(query.lowercased())}
    }
    
    func endSearchMovie() {
        isSearchMode = false
        movieViewModels = copyViewModels
    }
    
    func stopFooterAnimating() -> Bool {
        if nextPage > totalPages || isSearchMode {
            return true
        } else {
            return false
        }
    }
    
    var numberOfItemsInSection: Int {
        return movieViewModels.count
    }
    
    func isAllowedLoadMoreData() -> Bool {
        if !isLoading && nextPage <= totalPages && !isSearchMode{
            return true
        }
        return false
    }
    
    var searchResultMessage: String {
        if movieViewModels.count > 0 {
            return "Showing result of "
        } else {
            return "No result of "
        }
    }
        
    //MARK: - Private
    
    private func updateNextPage() {
        nextPage += 1
    }
    
    private func updateLoadingStatus() {
        self.isLoading = !isLoading
    }
}
