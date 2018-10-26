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

class DetailViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet private weak var backDropImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var overViewTextView: UITextView!
    @IBOutlet private weak var trailersTableView: UITableView!
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
    }
}
