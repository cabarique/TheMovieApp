//
//  File.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/25/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import Foundation

class MoviePageModel: MediaPageModel {
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let page = try container.decode(Int.self, forKey: .page)
        let totalPages = try container.decode(Int.self, forKey: .totalPages)
        let totalResults = try container.decode(Int.self, forKey: .totalResults)
        let data = try container.decode([MovieModel].self, forKey: .results)
        
        super.init(page: page, totalResults: totalResults, totalPages: totalPages, data: data)
    }
}
