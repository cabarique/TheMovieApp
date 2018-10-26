//
//  TrailerViewController.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/25/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import YouTubePlayer
import SnapKit

final class TrailerViewController: UIViewController {
    
    fileprivate var videoPlayer: YouTubePlayerView!
    fileprivate var videoId = ""
    let trailerModel: TrailerModel
    
    init(trailerModel: TrailerModel) {
        self.trailerModel = trailerModel
        self.videoId = trailerModel.key
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        let header = UIView(frame: CGRect.zero).with { header in
            self.view.backgroundColor = UIColor.black
            self.view.addSubview(header)
            header.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.height.equalTo(60)
            }
            header.backgroundColor = UIColor.black
            let titleLabel = UILabel(frame: CGRect.zero).with { title in
                title.textColor = .white
                title.text = trailerModel.name
                title.textAlignment = .left
                title.font = UIFont.boldSystemFont(ofSize: 12)
                header.addSubview(title)
            }
            let closeButton = UIButton(frame: CGRect.zero).with { closeButton in
                header.addSubview(closeButton)
                closeButton.setTitle("╳", for: .normal)
                closeButton.setTitleColor(.white, for: .normal)
                closeButton.rx.tap
                    .asDriver()
                    .drive(onNext: { [weak self] in
                        self?.dismiss(animated: true)
                    })
                    .disposed(by: self.disposeBag)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(24)
                make.top.bottom.equalToSuperview()
                make.right.equalTo(closeButton.snp.left).offset(1)
            }
            
            closeButton.snp.makeConstraints { make in
                make.size.equalTo(41)
                make.right.equalToSuperview().inset(24)
                make.top.equalToSuperview()
            }
        }
        
        self.videoPlayer = YouTubePlayerView(frame: CGRect.zero).with {
            self.view.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(header.snp.bottom)
                make.left.bottom.right.equalToSuperview()
            }
            $0.loadVideoID(videoId)
            $0.delegate = self
            $0.backgroundColor = UIColor.black
        }
    }
}

extension TrailerViewController: YouTubePlayerDelegate {
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        videoPlayer.play()
    }
}

