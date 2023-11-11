//
//  SectionHeaderView.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/11/07.
//

import UIKit
import RxSwift

final class SectionHeaderView: UICollectionReusableView {
    
    static let identifier = "SectionHeaderView"
    private let detailButton = UIButton(type: .custom)
    private let nameLabel = UILabel()
    var detailButtonAction: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfig()
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setName(_ name: String?) {
        nameLabel.text = name
    }
    
    @objc
    private func detailButtonTapped() {
        detailButtonAction?(self.nameLabel.text ?? "알 수 없음")
    }
    
    private func setConfig() {
        backgroundColor = .white
        
        var config = UIButton.Configuration.plain()
        let image = UIImage(systemName: "chevron.right")
        config.image = image
        config.imagePadding = 8
        config.imagePlacement = .trailing
        config.baseForegroundColor = .black
        config.preferredSymbolConfigurationForImage = .init(pointSize: 10)
        config.attributedTitle = AttributedString("더보기", attributes: .init([.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.black]))
        detailButton.configuration = config
        detailButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
        
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textColor = .black
    }
    
    private func setUI() {
        addSubview(nameLabel)
        addSubview(detailButton)
    }
    
    private func setConstraint() {
        detailButton.snp.makeConstraints { make in
            make.trailing.equalTo(-16)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.bottom.equalToSuperview()
        }
    }
}
