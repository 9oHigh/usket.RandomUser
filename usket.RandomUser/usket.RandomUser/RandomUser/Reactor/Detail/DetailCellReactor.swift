//
//  DetailCellReactor.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/11/07.
//

import ReactorKit
import UIKit

final class DetailCellReactor: Reactor {
    
    typealias State = CellState
    typealias Action = NoAction
    
    struct CellState {
        var personInfoDetail: PersonInfoDetail
        var sameAreaPeople: PeopleDetail
        var isExpanded: Bool = false
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
}
