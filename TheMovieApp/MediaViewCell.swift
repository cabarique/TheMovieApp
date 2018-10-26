//
//  MovieViewCell.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/25/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import UIKit
import RxSwift

class MediaViewCell: UITableViewCell {
    
    fileprivate var didSelectMediaSubject = ReplaySubject<MediaModel>.create(bufferSize: 1)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.cellContentView)
        self.cellContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = .zero
        self.layoutMargins = .zero
        self.selectionStyle = .none
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: properties
    
    var cellContentView: MediaContentViewCell = {
        return MediaContentViewCell(media: [])
    }()
    
    func configureCell(_ data: [MediaModel]) {
        cellContentView.media.accept(data)
        cellContentView.didSelectMedia.bind(to: self.didSelectMediaSubject).disposed(by: self.disposeBag)
    }
}

extension MediaViewCell {
    var didSelectMedia: Observable<MediaModel> {
        return self.didSelectMediaSubject.asObserver()
    }
}
