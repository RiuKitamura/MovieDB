//
//  Movie.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import Foundation

struct Movie: Decodable {
    let results: [MovieResult]
}

struct MovieResult: Decodable {
    let id: Int
    let backdrop_path: String?
    let poster_path: String?
    let title: String
}
