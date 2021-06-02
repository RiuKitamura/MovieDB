//
//  HomeListViewModel.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import Foundation

class HomeListViewModel {
    private(set) var bannerViewModels = [MovieViewModel]()
    private(set) var popularMovieViewModels = [MovieViewModel]()
    private(set) var comingSoonViewModels = [MovieViewModel]()
    
    func fetchMovie(completion: @escaping(Bool) -> Void) {
        
        guard let movieUrl = Constan.Url.urlForMovie else {
            completion(false)
            return
        }
        
        let movieResouce = Resource<Movie>(url: movieUrl) { (data) -> Movie? in
            let movie = try? JSONDecoder().decode(Movie.self, from: data)
            return movie
        }
        
        WebService().loadMovie(resource: movieResouce) { (result) in
            switch result {
            case .success(let movie):
                let bennerVM = movie!.results.map{MovieViewModel($0, isBaner: true)}
                self.bannerViewModels = bennerVM
                let popularVM = movie!.results.map{MovieViewModel($0, isBaner: false)}
                self.popularMovieViewModels = popularVM
                
                // fetch coming soon movie
                self.fetchComingSoon { (isSucces) in
                    if isSucces {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
                
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    private func fetchComingSoon(completion: @escaping(Bool) -> Void) {
        
        guard let comingSoonUrl = Constan.Url.urlForComingMovie else {
            completion(false)
            return
        }
        
        let comingMovieResouce = Resource<Movie>(url: comingSoonUrl) { (data) -> Movie? in
            let movie = try? JSONDecoder().decode(Movie.self, from: data)
            return movie
        }
        
        WebService().loadMovie(resource: comingMovieResouce) { (result) in
            switch result {
            case .success(let movie):
                let vm = movie!.results.map{MovieViewModel($0, isBaner: false)}
                self.comingSoonViewModels = vm
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    var numberOfItemsInSection: Int {
        if bannerViewModels.count > 0 && popularMovieViewModels.count > 0 && comingSoonViewModels.count > 0 {
            return 1
        } else {
            return 0
        }
        
    }
}

//MARK: - MovieViewModel

struct MovieViewModel {
    private let movie: MovieResult
    private let isBaner: Bool
    init(_ movie: MovieResult, isBaner: Bool) {
        self.movie = movie
        self.isBaner = isBaner
    }
    
    var id: Int {
        return movie.id
    }
    
    var posterLink: String {
        if isBaner {
            return Constan.Url.fosterBaseUrlw780 + (movie.backdrop_path ?? "")
        } else {
            return Constan.Url.fosterBaseUrlw154 + (movie.poster_path ?? "")
        }
    }

    
    var title: String {
        return movie.title
    }
    
    func suldHideTitle() -> Bool {
        movie.poster_path == nil ? false : true
    }
}
