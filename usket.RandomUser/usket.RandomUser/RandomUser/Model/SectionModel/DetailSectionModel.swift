//
//  DetailSectionModel.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/11/07.
//

import RxDataSources

struct DetailSectionModel {
    var title: String?
    var items: PeopleDetail
}

extension DetailSectionModel: SectionModelType {
    init(original: DetailSectionModel, items: [PersonInfoDetail]) {
        self = original
        self.items = items
    }
}
