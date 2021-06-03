//
//  Constan.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import Foundation

struct Constan {
    static let apiKey = "56fa41d43e6c554ac010f502aa539c71"
    
    struct Url {
        static func urlForMovie(page: Int) -> URL? {
            return URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(Constan.apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)")
        }
        
        static var urlForComingMovie: URL? {
            let date = Date()
            let calendar = Calendar.current

            let year = calendar.component(.year, from: date) + 1
            
            return URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(Constan.apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&year=\(year)")
        }
        
        static let fosterBaseUrlw154 = "https://image.tmdb.org/t/p/w154"
        static let fosterBaseUrlw780 = "https://image.tmdb.org/t/p/w780"
        static let castImageBaseUrlw92 = "https://image.tmdb.org/t/p/w92"
    }
}
