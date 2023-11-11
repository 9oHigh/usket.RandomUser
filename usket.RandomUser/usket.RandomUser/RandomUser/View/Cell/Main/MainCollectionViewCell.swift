//
//  MainTableViewCell.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/10/18.
//

import UIKit
import ReactorKit

final class MainCollectionViewCell: UICollectionViewCell, View {
    
    static let identifier = "MainCollectionViewCell"
    private let profileImageView = UIImageView()
    private let infoLabel = UILabel()
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfigure()
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        infoLabel.text = nil
    }
    
    func bind(reactor: MainCellReactor) {
        reactor.state.map { $0.personInfoDetail }
            .subscribe(onNext: { [weak self] info in
                self?.profileImageView.loadImageFromUrl(url: URL(string: info.imageUrl), placeholder: nil)
                self?.infoLabel.text = info.name + "\n\(info.age)세"
            })
            .disposed(by: disposeBag)
    }
    
    private func setConfigure() {
        backgroundColor = .white
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.font = .systemFont(ofSize: 9)
        infoLabel.textColor = .black
    }
    
    private func setUI() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(infoLabel)
    }
    
    private func setConstraint() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.65)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
