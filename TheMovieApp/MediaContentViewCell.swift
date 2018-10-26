//
//  MoviewContentViewCell.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/25/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

let kCollectionCellId = "collectionCellID"

protocol MediaContentViewCellOutput {
    var didSelectMedia: Observable<MediaModel> { get }
}

class MediaContentViewCell: UIView {
    
    var collectionView: UICollectionView!
    var media: BehaviorRelay<[MediaModel]>
    
    //Subject
    fileprivate var didSelectMediaSubject = PublishSubject<MediaModel>()
    
    init(media: [MediaModel]){
        self.media = BehaviorRelay<[MediaModel]>(value: media)
        super.init(frame: CGRect.zero)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then { cv in
            self.addSubview(cv)
            cv.showsHorizontalScrollIndicator = false
            cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCollectionCellId)
            cv.rx.setDelegate(self).disposed(by: self.disposeBag)
            cv.snp.makeConstraints{ make in
                make.edges.equalToSuperview()
            }
            
            let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, MediaModel>>(configureCell: { (_,
                cv: UICollectionView,
                ip: IndexPath,
                item: MediaModel) -> UICollectionViewCell in
                let cell: UICollectionViewCell = cv
                    .dequeueReusableCell(
                        withReuseIdentifier: kCollectionCellId,
                        for: ip)
                cell.backgroundColor = UIColor.gray
                cell.backgroundView = UIView(frame: cell.frame).then { bv in
                    guard let posterUrl = item.getPosterURL(),
                        let dataImage = try? Data(contentsOf: posterUrl) else { return }
                    let imageView = UIImageView(image: UIImage(data: dataImage))
                    bv.addSubview(imageView)
                    imageView.snp.makeConstraints{ make in
                        make.edges.equalToSuperview()
                    }
                }
                return cell
            })
            
            self.media
                .map { [SectionModel(model: "main", items: $0)] }
                .bind(to: cv.rx.items(dataSource: dataSource))
                .disposed(by: self.disposeBag)
        }
        
        self.rxBind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func rxBind() {
        self.collectionView.rx.modelSelected(MediaModel.self)
            .bind(to: didSelectMediaSubject)
            .disposed(by: self.disposeBag)
    }
}

extension MediaContentViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
}

extension MediaContentViewCell: MediaContentViewCellOutput {
    var didSelectMedia: Observable<MediaModel> {
        return self.didSelectMediaSubject.asObserver()
    }
}
