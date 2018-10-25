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
    
    private let mediaPageSubject = ReplaySubject<MediaModel>.create(bufferSize: 1)
    var mediaSection = BehaviorRelay<[MediaSection]>(value: [])
    private var disposeBag = DisposeBag()
    init(){
        let json = """
                {
                 "name": "Mr. Robot",
                 "id": 123456,
                 "posterPath": "/vC324sdfcS313vh9QXwijLIHPJp.jpg",
                }
                """.data(using: .utf8)! // our data in native (JSON) format
        guard let mediaModel = try? JSONDecoder().decode(MediaModel.self, from: json) else { return }
        mediaPageSubject.onNext(mediaModel)
        mediaSectionObservable.bind(to: mediaSection).disposed(by: self.disposeBag)
    }
}

extension MediaMainViewModel {
    var mediaSectionObservable: Observable<[MediaSection]> {
        return mediaPageSubject.map {
            [MediaSection(title: "Top rated",
                         mediaType: MediaType.movie,
                         data: [$0],
                         mediaCategory: .topRated),
             MediaSection(title: "upcomming",
                          mediaType: MediaType.movie,
                          data: [$0],
                          mediaCategory: .upComming)]}.asObservable()
    }
    
    
}
