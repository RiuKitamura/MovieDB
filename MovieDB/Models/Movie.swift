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
    let id: Int
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
//    var didFavorite: Bool = false
    
//    private enum CodingKeys: String, CodingKey { case id, backdrop_path, genres, title, overview, release_date, vote_average, vote_count, casts, poster_path, videos}
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int.self, forKey: .id)
//        backdrop_path = try container.decode(String.self, forKey: .backdrop_path)
//        genres = try container.decode([GenreDetail].self, forKey: .genres)
//        title = try container.decode(String.self, forKey: .title)
//        overview = try container.decode(String.self, forKey: .overview)
//        release_date = try container.decode(String.self, forKey: .release_date)
//        vote_average = try container.decode(Double.self, forKey: .vote_average)
//        vote_count = try container.decode(Int.self, forKey: .vote_count)
//        casts = try container.decode(Casts.self, forKey: .casts)
//        poster_path = try container.decode(String.self, forKey: .poster_path)
//        videos = try container.decode(Video.self, forKey: .videos)
//    }
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
