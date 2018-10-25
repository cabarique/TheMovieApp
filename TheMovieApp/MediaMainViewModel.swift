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
    
    //Movies Subjects
    private let topRatedMoviesSubject = ReplaySubject<[MediaModel]>.create(bufferSize: 1)
    private let popularMoviesSubject = ReplaySubject<[MediaModel]>.create(bufferSize: 1)
    private let upcommingMoviesSubject = ReplaySubject<[MediaModel]>.create(bufferSize: 1)
    
    //Tv Subjects
    private let topRatedTvSubject = ReplaySubject<[MediaModel]>.create(bufferSize: 1)
    private let popularTvSubject = ReplaySubject<[MediaModel]>.create(bufferSize: 1)
    private let upcommingTvSubject = ReplaySubject<[MediaModel]>.create(bufferSize: 1)
    
    var mediaSection = BehaviorRelay<[MediaSection]>(value: [])
    private var disposeBag = DisposeBag()
    
    init(){
        //Movies
        theMovieDBAPI.rx.request(.topRatedMovies(1))
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
                    self.upcommingMoviesSubject.onNext(model.data)
                case .error(_):
                    break
                }
                
            }.disposed(by: self.disposeBag)
        
        //Tvs
        theMovieDBAPI.rx.request(.topRatedTV(1))
            .map(TvPageModel.self).subscribe{ event in
                switch event {
                case let .success(model):
                    self.topRatedTvSubject.onNext(model.data)
                case .error(_):
                    break
                }
                
            }.disposed(by: self.disposeBag)
        
        theMovieDBAPI.rx.request(.popularTV(1))
            .map(TvPageModel.self).subscribe{ event in
                switch event {
                case let .success(model):
                    self.popularTvSubject.onNext(model.data)
                case .error(_):
                    break
                }
                
            }.disposed(by: self.disposeBag)
        
        theMovieDBAPI.rx.request(.upcommingTV(1))
            .map(TvPageModel.self).subscribe{ event in
                switch event {
                case let .success(model):
                    self.upcommingTvSubject.onNext(model.data)
                case .error(_):
                    break
                }
                
            }.disposed(by: self.disposeBag)
        
        mediaSectionObservable.bind(to: mediaSection).disposed(by: self.disposeBag)
    }
}

extension MediaMainViewModel {
    var mediaSectionObservable: Observable<[MediaSection]> {
        //Movies
        let topRatedMovieSection = self.topRatedMoviesSubject.map {
            MediaSection(title: "Top rated movies",
                         mediaType: MediaType.movie,
                         data: $0,
                         mediaCategory: .topRated)
        }
        
        let popularMovieSection = self.popularMoviesSubject.map {
            MediaSection(title: "Popular movies",
                         mediaType: MediaType.movie,
                         data: $0,
                         mediaCategory: .popular)
        }
        
        let upcommingMovieSection = self.upcommingMoviesSubject.map {
            MediaSection(title: "Upcomming movies",
                         mediaType: MediaType.movie,
                         data: $0,
                         mediaCategory: .upComming)
        }
        
        //Tvs
        let topRatedTvSection = self.topRatedTvSubject.map {
            MediaSection(title: "Top rated tv shows",
                         mediaType: MediaType.tv,
                         data: $0,
                         mediaCategory: .topRated)
        }
        
        let popularTvSection = self.popularTvSubject.map {
            MediaSection(title: "Popular  tv shows",
                         mediaType: MediaType.tv,
                         data: $0,
                         mediaCategory: .popular)
        }
        
        let upcommingTvSection = self.upcommingTvSubject.map {
            MediaSection(title: "Upcomming  tv shows",
                         mediaType: MediaType.tv,
                         data: $0,
                         mediaCategory: .upComming)
        }
        
        return Observable.combineLatest(topRatedMovieSection,
                                        popularMovieSection,
                                        upcommingMovieSection,
                                        topRatedTvSection,
                                        popularTvSection,
                                        upcommingTvSection).map { (topMovie,
                                            popularMovie,
                                            upcommingMovie,
                                            topTv,
                                            popularTv,
                                            upcommingTv) -> [MediaSection] in
            [upcommingMovie, topMovie, popularMovie, upcommingTv, popularTv, topTv]
        }
    }
    
}
