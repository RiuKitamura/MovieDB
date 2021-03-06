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
        
        guard let movieUrl = Constan.Url.urlForMovie(page: 1) else {
            completion(false)
            return
        }
        
        let movieResouce = Resource<Movie>(url: movieUrl) { (data) -> Movie? in
            let movie = try? JSONDecoder().decode(Movie.self, from: data)
            return movie
        }
        
        WebService().loadMovie(resource: movieResouce) {[weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let movie):
                guard let movie = movie else {
                    completion(false)
                    return
                }
                let bennerVM = movie.results.map{MovieViewModel($0, isBaner: true)}
                self.bannerViewModels = bennerVM
                let popularVM = movie.results.map{MovieViewModel($0, isBaner: false)}
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
        
        WebService().loadMovie(resource: comingMovieResouce) {[weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let movie):
                guard let movie = movie else {
                    completion(false)
                    return
                }
                let vm = movie.results.map{MovieViewModel($0, isBaner: false)}
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
    
    var releaseDate: String {
        return movie.release_date ?? "-"
    }
    
//    func suldHideTitle() -> Bool {
//        movie.poster_path == nil ? false : true
//    }
}
