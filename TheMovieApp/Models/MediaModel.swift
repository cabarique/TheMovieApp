//
//  MediaModel.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/25/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import Foundation

let kImageUrl = "https://image.tmdb.org/t/p/w500/"
class MediaModel: Decodable {
    let id: Int
    let name: String
    let posterPath: String?
    let overview: String
    
    init(id: Int, name: String, overview: String, posterPath: String? = nil) {
        self.id = id
        self.name = name
        self.posterPath = posterPath
        self.overview = overview
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("decoder needs to be implemented")
    }
    
    func getPosterURL() -> URL? {
        guard let posterPath = self.posterPath else { return nil }
        return URL(string: kImageUrl + posterPath)
    }
}
