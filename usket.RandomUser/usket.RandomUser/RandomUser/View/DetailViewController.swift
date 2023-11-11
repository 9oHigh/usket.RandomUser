//
//  DetailViewController.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/10/17.
//

import UIKit
import ReactorKit
import RxDataSources
import RxSwift

final class DetailViewController: UIViewController, View {
    
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfig()
        setUI()
        setConstraint()
    }
    
    func bind(reactor: DetailReactor) {
        
        let dataSource = RxTableViewSectionedReloadDataSource<DetailSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as? DetailTableViewCell
            let expandedIndexPath = reactor.currentState.expandedIndexPath
            
            cell?.reactor = DetailCellReactor(initialState: .init(personInfoDetail: item, sameAreaPeople: reactor.currentState.people.filter { $0.country == item.country && $0 != item}, isExpanded: indexPath == expandedIndexPath))

            return cell ?? UITableViewCell()
        })
        
        reactor.state
            .map { [DetailSectionModel(items: $0.people)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                reactor.action.onNext(.toggle(indexPath))
            })
            .disposed(by: disposeBag)
    }
    
    private func setConfig() {
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        activityIndicator.color = .black
        
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
    }
    
    private func setUI() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    private func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
}
