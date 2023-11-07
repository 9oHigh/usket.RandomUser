//
//  ViewController.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/10/13.
//

import UIKit
import SnapKit
import ReactorKit
import RxDataSources
import RxSwift

final class MainViewController: UIViewController, View, UIScrollViewDelegate {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfig()
        setUI()
        setConstraint()
        reactor?.action.onNext(.load(100))
    }
    
    func bind(reactor: MainReactor) {
        let dataSource = RxCollectionViewSectionedReloadDataSource<MainSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell
            cell?.reactor = MainCellReactor(initialState: .init(personInfo: item))
            return cell ?? UICollectionViewCell()
        }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.identifier,
                for: indexPath
            ) as? SectionHeaderView
            else {
                return UICollectionReusableView()
            }
            
            header.setName(reactor.currentState.sectionTitles[indexPath.section])
            
            return header
        })
        
        reactor.state
            .map { state in
                return state.sectionTitles.map { sectionTitle in
                    let people = state.sectionData[sectionTitle] ?? []
                    let items = Array(people.prefix(8))
                    return MainSectionModel(header: sectionTitle, items: items)
                }
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setConfig() {
        view.backgroundColor = .white
        navigationItem.title = "이상형을 찾아보자 👩‍❤️‍👨"
        
        activityIndicator.color = .black
        
        collectionView.backgroundColor = .white
        collectionView.refreshControl = refreshControl
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshUsers), for: .valueChanged)
        
        collectionView.delegate = self
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
    }
    
    private func setUI() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
    }
    
    private func setConstraint() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
    
    @objc
    private func refreshUsers() {
        reactor?.action.onNext(.load(100))
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 4 * 8) / 5
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
