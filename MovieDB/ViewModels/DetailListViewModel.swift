//
//  DetailListViewModel.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 03/06/21.
//

import UIKit

class DetailListViewModel {
    private let movieId: Int
    private(set) var movieDetailViewModel: MovieDetailViewModel?
    private let db = CoreDataManager()

    init(movieId: Int) {
        self.movieId = movieId
    }
    
    func fetchMovieDetail(completion: @escaping(Bool) -> Void) {
        
        guard let movieDetailUrl = Constan.Url.urlForMovieDetail(movieId: movieId) else {
            completion(false)
            return
        }
        
        print(movieDetailUrl)
        let movieDetailResource = Resource<MovieDetail>(url: movieDetailUrl) { (data) -> MovieDetail? in
            let movieDetail = try? JSONDecoder().decode(MovieDetail.self, from: data)
            return movieDetail
        }
        
        WebService().loadMovie(resource: movieDetailResource) {[weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .success(let movieDetail):
                guard let movie = movieDetail else {
                    completion(false)
                    return
                }
                self.movieDetailViewModel = MovieDetailViewModel(movie)
                self.cekBookmark()
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func addToFavorite(_ movie: MovieDetail, competion: @escaping(Bool) -> Void) {
        db.addFavorite(movie: movie) { (isSuccess) in
            if isSuccess {
                self.cekBookmark()
                competion(true)
            } else {
                competion(false)
            }
        }
    }
    
    func deleteFavorite(_ movie: MovieDetail, competion: @escaping(Bool) -> Void) {
        
        let pred = NSPredicate(format: "movieId == %@", String(movie.id))
        
        db.deleteSpecificData(ofType: Favorite.self, with: pred) { (isSuccess) in
            if isSuccess {
                self.movieDetailViewModel?.updateFavoriteStatus(status: false)
                competion(true)
            } else {
                self.movieDetailViewModel?.updateFavoriteStatus(status: true)
                competion(false)
            }
        }
                
    }
    
    private func cekBookmark() {
        let pred = NSPredicate(format: "movieId == %@", String(movieId))
        let data = db.fetchData(ofType: Favorite.self, with: pred)
        if data != nil {
            self.movieDetailViewModel?.updateFavoriteStatus(status: true)
        } else {
            self.movieDetailViewModel?.updateFavoriteStatus(status: false)
        }
    }
    
    var numberOfOverviewItemsInSection: Int {
        movieDetailViewModel?.overview == nil ? 0 : 1
    }
    
    var numberOfCastItemsInSection: Int {
        movieDetailViewModel?.numberOfCastItemsInSection ?? 0
    }
    
    func shuldHideHeader() -> Bool {
        return movieDetailViewModel == nil
    }
}

//MARK: - MovieDetailViewModel

struct MovieDetailViewModel {
    private var movieDetail: MovieDetail
    private let castDetailViewModels: [CastDetailViewModel]?
    private(set) var didFavorite = false
    
    init(_ movieDetail: MovieDetail) {
        self.movieDetail = movieDetail
        let castVM = movieDetail.casts.cast.map{CastDetailViewModel($0)}
        self.castDetailViewModels = castVM
    }
    
    var numberOfCastItemsInSection: Int {
        if castDetailViewModels?.count ?? 0 > 0 {
            return 1
        }
        return 0
    }
    
    var movieTitle: String {
        movieDetail.title
    }
    
    var releaseDate: String {
        movieDetail.release_date ?? "-"
    }
    
    var genres: NSAttributedString {
        let atribute = NSMutableAttributedString()
        for index in 0..<movieDetail.genres.count {
            if index != 0 {
                atribute.append(NSAttributedString(string: " ⊚ ",
                                                   attributes: [
                                                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12),
                                                    NSAttributedString.Key.foregroundColor: UIColor.dbYellow]))
            }
            atribute.append(NSAttributedString(string: movieDetail.genres[index].name))
        }
        return atribute
    }
    
    var posterLink: String {
        if let path = movieDetail.backdrop_path {
            return Constan.Url.fosterBaseUrlw780 + path
        } else {
            return Constan.Url.fosterBaseUrlw780 + (movieDetail.poster_path ?? "")
        }
    }
    
    var overview: String {
        movieDetail.overview ?? ""
    }
    
    func getAllCastViewModel() -> [CastDetailViewModel]? {
        castDetailViewModels
    }
    
    func trailerUrl() -> URL? {
        
        guard movieDetail.videos.results.count > 0 else {
            return nil
        }
        return Constan.Url.urlForTrailer(key: movieDetail.videos.results[0].key)
    }
    
    var movieDetailData: MovieDetail {
        movieDetail
    }
    
    var favoriteButtonTitle: String {
        if didFavorite {
            return "Remove from Favorite"
        } else {
            return "Add to Favorite"
        }
    }
    
    var favoriteButtonTitleImageName: String {
        if didFavorite {
            return "fdf"
        } else {
            return "plus"
        }
    }
    
    mutating func updateFavoriteStatus(status: Bool) {
        self.didFavorite = status
    }
}

//MARK: - CastDetailViewModel

struct CastDetailViewModel {
    private let castDetail: CastDetail
    
    init(_ castDetail: CastDetail) {
        self.castDetail = castDetail
    }
    
    var isProfilePathEmpty: Bool {
        castDetail.profile_path == nil
    }
    
    var imageUrlString: String {
        Constan.Url.castImageBaseUrlw92 + (castDetail.profile_path ?? "")
    }
    
    var castName: String {
        castDetail.name
    }
    
    var initialName: String {
        String(castDetail.name.prefix(1))
    }
}
