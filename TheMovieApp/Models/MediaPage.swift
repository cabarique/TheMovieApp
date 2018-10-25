//
//  MediaPage.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/25/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import Foundation

class MediaPage: Decodable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
}
