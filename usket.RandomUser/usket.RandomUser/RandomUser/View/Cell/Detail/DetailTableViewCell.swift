//
//  DetailTableViewCell.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/11/07.
//

import UIKit
import ReactorKit
import SnapKit

final class DetailTableViewCell: UITableViewCell, View {
    
    static let identifier = "DetailTableViewCell"
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    private let emailLabel = UILabel()
    private let phoneNumberLabel = UILabel()
    private let countryLabel = UILabel()
    
    private let sameAreaIntro = UILabel()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private var collectionViewHeightConstraint: Constraint?
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConfigure()
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
        ageLabel.text = nil
        emailLabel.text = nil
        phoneNumberLabel.text = nil
        countryLabel.text = nil
    }
    
    func bind(reactor: DetailCellReactor) {
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.personInfoDetail }
            .subscribe(onNext: { [weak self] info in
                self?.profileImageView.loadImageFromUrl(url: URL(string: info.imageUrl), placeholder: nil)
                self?.nameLabel.text = "이름: " + info.name
                self?.ageLabel.text = "나이: " + "\(info.age)세"
                self?.emailLabel.text = "이메일: " + info.email
                self?.phoneNumberLabel.text = "전화번호: " + info.cell
                self?.countryLabel.text = "국가: " + info.country
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.sameAreaPeople.prefix(8) }
            .bind(to: collectionView.rx.items(cellIdentifier: MainCollectionViewCell.identifier, cellType: MainCollectionViewCell.self)) { ( indexPath, item, cell) in
                let reactor = MainCellReactor(initialState: .init(personInfoDetail: item))
                cell.reactor = reactor
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isExpanded }
            .subscribe(onNext: { [weak self] isExpanded in
                UIView.animate(withDuration: 0.5) {
                    if isExpanded {
                        // 데이터 없으면 아무것도 할 필요없음
                        if reactor.currentState.sameAreaPeople.isEmpty {
                            return
                        } else {
                            self?.showCollectionView()
                        }
                    } else {
                        self?.hideCollectionView()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setConfigure() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.24
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor.black.cgColor

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        backgroundColor = .clear
        selectionStyle = .none
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        sameAreaIntro.isHidden = true
        sameAreaIntro.text = "같은 동네에 살고있어요 :)"
        
        collectionView.backgroundColor = .white
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        
        [nameLabel, ageLabel, emailLabel, phoneNumberLabel, countryLabel, sameAreaIntro].forEach {
            $0.font = .boldSystemFont(ofSize: 12)
            $0.textColor = .black
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
    }
    
    private func setUI() {
        [profileImageView, nameLabel, ageLabel, emailLabel, phoneNumberLabel, countryLabel, sameAreaIntro, collectionView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setConstraint() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.leading.equalTo(16)
            make.height.equalTo(128)
            make.width.equalTo(profileImageView.snp.height)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.equalTo(-16)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.equalTo(-16)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.equalTo(-16)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.equalTo(-16)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.equalTo(-16)
        }
        
        sameAreaIntro.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.leading.equalTo(16)
            make.trailing.equalToSuperview()
            make.height.equalTo(sameAreaIntro.font.pointSize).priority(.high)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sameAreaIntro.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
            collectionViewHeightConstraint = make.height.equalTo(0).priority(.high).constraint
        }
    }
    
    private func showCollectionView() {
        collectionViewHeightConstraint?.update(offset: 120)
        sameAreaIntro.isHidden = false
    }
    
    private func hideCollectionView() {
        collectionViewHeightConstraint?.update(offset: 0)
        sameAreaIntro.isHidden = true
    }
}

extension DetailTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 4 * 8) / 5
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
