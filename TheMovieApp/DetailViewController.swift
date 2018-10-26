//
//  DetailViewController.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/25/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

let kTrailerViewCell = "trailerViewCell"

class DetailViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet private weak var backDropImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var overViewTextView: UITextView!
    @IBOutlet private weak var trailersTableView: IntrinsicTableView!
    @IBOutlet weak var closeButton: UIButton!
    
    private var media: MediaModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let media = media else {
            fatalError("configuremedia: needs to be called before presenting")
        }
        self.titleLabel.text = media.name
        self.overViewTextView.text = media.overview
        guard let posterUrl = media.getPosterURL(),
            let dataImage = try? Data(contentsOf: posterUrl) else { return }
        self.backDropImageView.image = UIImage(data: dataImage)
        self.trailersTableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.keyboardDismissMode = .onDrag
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            $0.bounces = false
            $0.register(UITableViewCell.self, forCellReuseIdentifier: kTrailerViewCell)
            $0.rx.setDelegate(self).disposed(by: disposeBag)
        }
        self.rxBind()
    }
    
    func configure(media: MediaModel){
        self.media = media
    }
    
    private func rxBind(){
        self.closeButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TrailerModel>> (configureCell: { (_,
            tv: UITableView,
            ip: IndexPath,
            item: TrailerModel) -> UITableViewCell in
            
            let cell = tv.dequeueReusableCell(
                    withIdentifier: kTrailerViewCell,
                    for: ip)
            
            let youtubeUrl = "https://img.youtube.com/vi/\(item.key)/hqdefault.jpg"
            if let posterUrl = URL(string: youtubeUrl),
                let dataImage = try? Data(contentsOf: posterUrl) {
                cell.backgroundView = UIImageView(image: UIImage(data: dataImage))
                cell.backgroundColor = UIColor.green
                cell.selectionStyle = .none
            }
            return cell
        }, titleForFooterInSection: { (table, section) -> String? in
            guard let model = try? table.model(at: IndexPath(item: 0, section: section)) as? TrailerModel else { return nil }
            return model?.name
        })
        
        self.trailersTableView.rx
            .modelSelected(TrailerModel.self)
            .asDriver(onErrorDriveWith: Driver.never())
            .drive(onNext: { model in
                let player = TrailerViewController(trailerModel: model).with {
                    $0.modalPresentationStyle = .overFullScreen
                    $0.modalTransitionStyle = .crossDissolve
                }
                self.present(player, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.getTrailersObserver()
            .map {
                $0.results.map {
                    SectionModel(model: $0.id, items: [$0])
                }
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { trailers in
                let trailerSections = Observable.just(trailers)
                trailerSections.debug("===")
                    .bind(to: self.trailersTableView.rx.items(dataSource: dataSource))
                    .disposed(by: self.disposeBag)
                self.trailersTableView.beginUpdates()
                self.trailersTableView.endUpdates()
            }) { (error) in
               print(error.localizedDescription)
            }
            .disposed(by: self.disposeBag)

        
    }
    
    private func getTrailersObserver()  -> PrimitiveSequence<SingleTrait, TrailersModel>{
        if let movie = media as? MovieModel {
            return theMovieDBAPI.rx.request(.trailerVideoMovies(movie.id)).map(TrailersModel.self)
        } else if let tv = media as? TVModel {
            return theMovieDBAPI.rx.request(.trailerVideoTV(tv.id)).map(TrailersModel.self)
        }else{
            return PrimitiveSequence<SingleTrait, TrailersModel>.never()
        }
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.backgroundColor = .black
            headerView.contentView.backgroundColor = .black
            headerView.textLabel?.textColor = .white
        }
    }
}

class IntrinsicTableView: UITableView {
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return contentSize
    }
    
}
