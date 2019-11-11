//
//  Movie.swift
//  webservicesexample
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 11/8/19.
//  Copyright © 2019 aldoBonilla. All rights reserved.
//

import Foundation

struct Movie: Decodable, CustomStringConvertible, Hashable {
    
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAvg: Double
    let votes: Int
    let runtime: Int?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, status
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAvg = "vote_average"
        case votes = "vote_count"
    }

    var description: String {
        return "Movie with id: \(id), title: \(originalTitle)"
    }
    
    var hashValue: Int {
        return id
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var posterURL: String {
        return "\(movieServerURL)\(imdbResourcesURL)\(posterPath ?? "")"
    }
}
