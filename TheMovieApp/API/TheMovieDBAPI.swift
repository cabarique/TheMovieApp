//
//  TheMovieDBAPI.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/25/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import Foundation
import Moya

var theMovieDBAPI = MoyaProvider<theMovieDBEndPoints>(plugins: [CachePolicyPlugin()])
private let kURL = "https://api.themoviedb.org/3/"
private let kAPIToken = "28499075fc4a6412fc09ef87aedbc359"

enum theMovieDBEndPoints {
    case popularMovies(Int)
    case topRatedMovies(Int)
    case upcommingMovies(Int)
    case trailerVideoMovies(Int)
    
    case popularTV(Int)
    case topRatedTV(Int)
    case upcommingTV(Int)
    case trailerVideoTV(Int)
    
    case search(String)
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
        case .trailerVideoMovies(let id):
            return "movie/\(id)/videos"
            
        case .popularTV(_):
            return "tv/popular"
        case .topRatedTV(_):
            return "tv/top_rated"
        case .upcommingTV(_):
            return "tv/airing_today"
        case .trailerVideoTV(let id):
            return "tv/\(id)/videos"
            
        case .search:
            return "search/multi"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .topRatedMovies:
            return MockedData.movieTopRated
        case .popularMovies,
             .upcommingMovies:
            return MockedData.popularMovies
        case .topRatedTV,
             .popularTV,
             .upcommingTV:
            return MockedData.popularTV
        default:
            return "".data(using: String.Encoding.utf8)!
        }
        
    }
    
    var task: Task {
        switch self {
        case .popularMovies(let page),
             .topRatedMovies(let page),
             .upcommingMovies(let page),
             .popularTV(let page),
             .topRatedTV(let page),
             .upcommingTV(let page):
            return .requestParameters(parameters: ["api_key": kAPIToken, "page": page], encoding: URLEncoding.default)
        case .trailerVideoMovies(_),
             .trailerVideoTV(_):
            return .requestParameters(parameters: ["api_key": kAPIToken], encoding: URLEncoding.default)
        case .search(let search):
            return .requestParameters(parameters: ["api_key": kAPIToken, "query": search], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}


protocol CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy { get }
}

final class CachePolicyPlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let cachePolicyGettable = target as? CachePolicyGettable {
            var mutableRequest = request
            mutableRequest.cachePolicy = cachePolicyGettable.cachePolicy
            return mutableRequest
        }
        
        return request
    }
}

extension theMovieDBEndPoints: CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy {
        return .returnCacheDataElseLoad
    }
}
