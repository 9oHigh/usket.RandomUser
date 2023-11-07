//
//  MainViewSection.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/10/19.
//

import RxDataSources

struct MainSectionModel {
    var header: String
    var items: People
}

extension MainSectionModel: SectionModelType {
    init(original: MainSectionModel, items: [PersonInfo]) {
        self = original
        self.items = items
    }
}
