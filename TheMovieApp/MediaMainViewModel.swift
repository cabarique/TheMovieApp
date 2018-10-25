//
//  MediaMainViewModel.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/24/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct MediaSection {
    let title: String
    let mediaType: MediaType
    let data: [MediaModel]
    let mediaCategory: MediaCategory
}

enum MediaCategory: String {
    case popular
    case topRated
    case upComming
}

enum MediaType {
    case movie
    case tv
}

class MediaMainViewModel {
    
    private let mediaPageSubject = ReplaySubject<[MediaModel]>.create(bufferSize: 1)
    private let topRatedMoviesSubject = ReplaySubject<[MediaModel]>.create(bufferSize: 1)
    private let popularMoviesSubject = ReplaySubject<[MediaModel]>.create(bufferSize: 1)
    private let upcommingSubject = ReplaySubject<[MediaModel]>.create(bufferSize: 1)
    var mediaSection = BehaviorRelay<[MediaSection]>(value: [])
    private var disposeBag = DisposeBag()
    
    init(){
        theMovieDBAPI.rx.request(.popularMovies(1))
            .map(MoviePageModel.self).subscribe{ event in
                switch event {
                case let .success(model):
                    self.topRatedMoviesSubject.onNext(model.data)
                case .error(_):
                    break
                }
                
            }.disposed(by: self.disposeBag)
        
        theMovieDBAPI.rx.request(.popularMovies(1))
            .map(MoviePageModel.self).subscribe{ event in
                switch event {
                case let .success(model):
                    self.popularMoviesSubject.onNext(model.data)
                case .error(_):
                    break
                }
                
            }.disposed(by: self.disposeBag)
        
        theMovieDBAPI.rx.request(.upcommingMovies(1))
            .map(MoviePageModel.self).subscribe{ event in
                switch event {
                case let .success(model):
                    self.upcommingSubject.onNext(model.data)
                case .error(_):
                    break
                }
                
            }.disposed(by: self.disposeBag)
        
        mediaSectionObservable.bind(to: mediaSection).disposed(by: self.disposeBag)
    }
}

extension MediaMainViewModel {
    var mediaSectionObservable: Observable<[MediaSection]> {
        let topRatedSection = self.topRatedMoviesSubject.map {
            MediaSection(title: "Top rated movies",
                         mediaType: MediaType.movie,
                         data: $0,
                         mediaCategory: .topRated)
        }
        
        let popularSection = self.popularMoviesSubject.map {
            MediaSection(title: "Popular movies",
                         mediaType: MediaType.movie,
                         data: $0,
                         mediaCategory: .popular)
        }
        
        let upcommingSection = self.popularMoviesSubject.map {
            MediaSection(title: "Upcomming movies",
                         mediaType: MediaType.movie,
                         data: $0,
                         mediaCategory: .upComming)
        }
        
        return Observable.combineLatest(topRatedSection, popularSection, upcommingSection).map { (top, popular, upcomming) -> [MediaSection] in
            [upcomming, top, popular]
        }
    }
    
}
