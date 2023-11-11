//
//  MainCellReactor.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/10/18.
//

import ReactorKit

final class MainCellReactor: Reactor {
    
    typealias State = CellState
    typealias Action = NoAction
    
    struct CellState {
        var personInfoDetail: PersonInfoDetail
    }
    
    let initialState: CellState
    
    init(initialState: CellState) {
        self.initialState = initialState
    }
}
