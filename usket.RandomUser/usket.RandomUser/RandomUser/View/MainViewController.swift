//
//  ViewController.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/10/13.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift

class MainViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func bind(reactor: MainReactor) {
        
    }
}
