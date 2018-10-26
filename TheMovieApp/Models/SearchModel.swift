//
//  SearchModel.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/26/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import Foundation

struct SearchPageModel: Decodable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    var results: [MediaModel] = []
    
    enum Keys: String, CodingKey { // declaring our keys
        case page = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results = "results"
    }
    
    enum MediaTypeKey: String, CodingKey {
        case mediaType = "media_type"
    }
    
    enum MediaType: String, Decodable {
        case tv
        case movie
        case person
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        page = try container.decode(Int.self, forKey: .page)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
        totalResults = try container.decode(Int.self, forKey: .totalResults)
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
        var results = [MediaModel]()
        
        var resultsArray = resultsContainer
        while !resultsContainer.isAtEnd {
            let mediaType = try resultsContainer.nestedContainer(keyedBy: MediaTypeKey.self)
            let type = try mediaType.decode(MediaType.self, forKey: .mediaType)
            switch type {
            case .tv:
                results.append(try resultsArray.decode(TVModel.self))
            case .movie:
                results.append(try resultsArray.decode(MovieModel.self))
            case .person:
                break
            }
        }
        
        self.results = results
        
    }
}
