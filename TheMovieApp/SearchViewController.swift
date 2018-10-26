//
//  SearchViewController.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/26/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

let kSearchViewCellId = "searchViewCellId"

class SearchViewController: UIViewController {

    @IBOutlet private weak var searchBarView: UISearchBar!
    @IBOutlet private weak var mediaCollectionView: UICollectionView!
    
    //Subjects
    private let mediaSubject = PublishSubject<[MediaModel]>()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mediaCollectionView.keyboardDismissMode = .onDrag
        
        self.mediaCollectionView.do { cv in
            cv.rx.setDelegate(self).disposed(by: self.disposeBag)
            cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kSearchViewCellId)
            
            let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, MediaModel>>(configureCell: { (_,
                cv: UICollectionView,
                ip: IndexPath,
                item: MediaModel) -> UICollectionViewCell in
                let cell: UICollectionViewCell = cv
                    .dequeueReusableCell(
                        withReuseIdentifier: kSearchViewCellId,
                        for: ip)
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
            
            self.mediaSubject
                .map { [SectionModel(model: "main", items: $0)] }
                .bind(to: cv.rx.items(dataSource: dataSource))
                .disposed(by: self.disposeBag)
        }
        
        self.rxBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchBarView.becomeFirstResponder()
    }
    
    private func rxBind() {
        self.searchBarView.rx.text
            .orEmpty // Make it non-optional
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .flatMap {
                theMovieDBAPI.rx.request(.search($0)).map(SearchPageModel.self)
            }
            .subscribe(onNext: { [unowned self] model in
                self.mediaSubject.onNext(model.results)
            })
            .disposed(by: self.disposeBag)
    }

}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHeight: CGFloat = (self.view.frame.width / 3)
        let totalWidth: CGFloat = (self.view.frame.width / 3)
        
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension SearchViewController: UISearchBarDelegate {
    
}
