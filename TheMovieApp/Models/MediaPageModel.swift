//
//  MediaPage.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/25/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import Foundation

class MediaPageModel: Decodable {
    var page: Int
    var totalResults: Int
    var totalPages: Int
    var data: [MediaModel]
    
    enum Keys: String, CodingKey { // declaring our keys
        case page = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results = "results"
    }
    
    init(page: Int, totalResults: Int, totalPages: Int, data: [MediaModel]) {
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
        self.data = data
    }
    required init(from decoder: Decoder) throws {
        fatalError("decoder needs to be implemented")
    }
}


