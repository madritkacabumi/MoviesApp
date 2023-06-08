//
//  MovieModel.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 5.6.23.
//

import Foundation

struct MovieModel: Codable {
    
    let id: Int
    let backdropPath: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let title: String
    let rating: Double
    let isWatched: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, rating, isWatched
    }
    
}
