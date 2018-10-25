//
//  TheMovieDBAPI.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/25/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import Foundation
import Moya

let theMovieDBAPI = MoyaProvider<theMovieDBEndPoints>()
private let kURL = "https://api.themoviedb.org/3/"
private let kAPIToken = "28499075fc4a6412fc09ef87aedbc359"

enum theMovieDBEndPoints {
    case popularMovies(Int)
    case topRatedMovies(Int)
    case upcommingMovies(Int)
}

extension theMovieDBEndPoints: TargetType {
    var baseURL: URL {
        return URL(string: kURL)!
    }
    
    var path: String {
        switch self {
        case .popularMovies:
            return "movie/popular"
        case .topRatedMovies:
            return "movie/top_rated"
        case .upcommingMovies:
            return "movie/upcoming"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .popularMovies(let page),
             .topRatedMovies(let page),
             .upcommingMovies(let page):
            return .requestParameters(parameters: ["api_key": kAPIToken, "page": page], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
