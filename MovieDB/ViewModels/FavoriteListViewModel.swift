//
//  FavoriteListViewModel.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 03/06/21.
//

import Foundation

class FavoriteListViewModel {
    
    private(set) var favorites = [FavoriteViewModel]()
    private var copyViewModels = [FavoriteViewModel]()

    private let db = CoreDataManager()
    private(set) var isSearchMode = false
    private(set) var query = ""


    func fetchData(completion: @escaping(Bool) -> Void) {
        let sort = NSSortDescriptor(key: "dateAdded", ascending: false)
        let data = db.fetchAllData(ofType: Favorite.self, with: [sort])
        guard let savedData = data else {
            completion(false)
            return
        }
        
        self.favorites = savedData.map{FavoriteViewModel($0)}
        self.copyViewModels = favorites
        completion(true)
    }
    
    func deleteFavorite(_ movieId: Int, at index: Int, competion: @escaping(Bool) -> Void) {
        
        let pred = NSPredicate(format: "movieId == %@", String(movieId))
        
        db.deleteSpecificData(ofType: Favorite.self, with: pred) { (isSuccess) in
            if isSuccess {
                self.favorites.remove(at: index)
                competion(true)
            } else {
                print("gagal hapus")
                competion(false)
            }
        }
    }
    
    func searchMovie(query: String) {
        isSearchMode = true
        self.query = query
        favorites = copyViewModels
        favorites = favorites.filter{ $0.movieTitle.lowercased().contains(query.lowercased())}
    }
    
    func endSearchMovie() {
        isSearchMode = false
        favorites = copyViewModels
    }
    
    func isDataEempty() -> Bool {
        return self.favorites.count == 0 ? true : false
    }
}

struct FavoriteViewModel {
    private let favorite: Favorite
    
    init(_ favorite: Favorite) {
        self.favorite = favorite
    }
    
    var posterLink: String {
        Constan.Url.fosterBaseUrlw780 + (favorite.imagePath ?? "")
    }
    
    var movieTitle: String {
        favorite.movieTitle ?? ""
    }
    
    var releaseYear: String {
        guard let date = favorite.releaseYear else { return ""}
        guard let year = Calendar.current.dateComponents([.year], from: date).year else { return ""}
        return "\(year)"
    }
    
    var genre: String {
        favorite.genre ?? ""
    }
    
    var movieId: Int? {
        Int(favorite.movieId ?? "0")
    }
}


