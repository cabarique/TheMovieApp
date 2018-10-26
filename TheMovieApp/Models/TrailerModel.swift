//
//  TrailerModel.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/25/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import Foundation

struct TrailersModel: Decodable {
    let results: [TrailerModel]
}

struct TrailerModel: Decodable {
    let id: String
    let key: String
    let name: String
}
