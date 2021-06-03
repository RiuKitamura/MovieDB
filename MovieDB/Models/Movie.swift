//
//  Movie.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import Foundation

struct Movie: Decodable {
    let results: [MovieResult]
    let total_pages: Int
}

struct MovieResult: Decodable {
    let id: Int
    let backdrop_path: String?
    let poster_path: String?
    let title: String
    let release_date: String?
    let vote_average: Double?
    
}

struct MovieDetail: Decodable {
    let backdrop_path: String?
    let genres: [GenreDetail]
    let title: String
    let overview: String?
    let release_date: String?
    let vote_average: Double?
    let vote_count: Int?
    let casts: Casts
    let poster_path: String?
    let videos: Video

}

// Genre
struct GenreDetail: Decodable {
    let name: String
}

// Casts
struct Casts: Decodable {
    let cast: [CastDetail]
}
struct CastDetail: Decodable {
    let name: String
    let profile_path: String?
    let character: String
}

// Videos
struct Video: Decodable {
    let results: [VideoDetail]
}

struct VideoDetail: Decodable {
    let key: String
    let name: String
    let type: String
}
