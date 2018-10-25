//
//  ViewController.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/24/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

let kMovieCellId: String = "MovieCellId"

class ViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet private weak var contentView: UIView!
    let viewModel = MediaMainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView = UITableView(frame: CGRect.zero, style: .plain).then { tv in
            self.contentView.addSubview(tv)
            tv.snp.makeConstraints{ make in
                make.edges.equalToSuperview()
            }
        }
        
        self.rxBind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //This makes the cell to recalculate height
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    private func rxBind(){
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MediaSection>>(configureCell: { (_,
            tv: UITableView,
            ip: IndexPath,
            item: MediaSection) -> UITableViewCell in
            let cell: MediaViewCell = tv
                .dequeueReusableCell(
                    withIdentifier: kMovieCellId,
                    for: ip) as! MediaViewCell
            cell.backgroundColor = UIColor.green
            switch item.mediaCategory{
            case .topRated:
                cell.backgroundColor = UIColor.blue
            default:
                cell.backgroundColor = UIColor.yellow
            }
            return cell
        }, titleForHeaderInSection: { (_, section: Int) -> String? in
            return self.viewModel.mediaSection.value[section].title
        })

        self.viewModel.mediaSectionObservable
            .map{
                $0.map { section in
                    SectionModel(model: section.title, items: [section])
                }
            }
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }

    var tableView: UITableView! {
        didSet {
            self.tableView.do {
                $0.showsVerticalScrollIndicator = false
                $0.keyboardDismissMode = .onDrag
                $0.backgroundColor = .clear
                $0.separatorStyle = .none
                $0.bounces = false
                $0.register(MediaViewCell.self, forCellReuseIdentifier: kMovieCellId)
                $0.rx.setDelegate(self).disposed(by: disposeBag)
                $0.allowsSelection = false
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

