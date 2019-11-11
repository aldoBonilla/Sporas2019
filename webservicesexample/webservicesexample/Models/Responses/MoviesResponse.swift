//
//  UpcomingMovies.swift
//  Imdb_ArcTouch
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 06/08/18.
//  Copyright © 2018 aldoBonilla. All rights reserved.
//

import Foundation

struct MoviesResponse: Decodable {
    
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case movies = "results"
    }
}
