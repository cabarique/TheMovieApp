//
//  TVModel.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/25/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import Foundation

class TVModel: MediaModel {
    enum Keys: String, CodingKey { // declaring our keys
        case id = "id"
        case name = "name"
        case overview = "overview"
        case posterPath = "poster_path"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let overview = try container.decode(String.self, forKey: .overview)
        let posterPath = try container.decode(String?.self, forKey: .posterPath)
        super.init(id: id, name: name, overview: overview, posterPath: posterPath)
    }
}
