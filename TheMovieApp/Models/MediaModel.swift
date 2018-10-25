//
//  MediaModel.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/25/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import Foundation

class MediaModel: Decodable {
    let id: Int
    let name: String
    let posterPath: String?
}
