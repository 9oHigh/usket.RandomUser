//
//  DetailReactor.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/11/07.
//

import Foundation
import ReactorKit

final class DetailReactor: Reactor {
    
    typealias State = SectionDetailState
    
    enum Action {
        case toggle(IndexPath)
    }
    
    enum Mutation {
        case toggle(IndexPath)
    }
    
    struct SectionDetailState {
        var isLoading: Bool = false
        var people: PeopleDetail
        var expandedIndexPath: IndexPath?
    }
    
    let initialState: State
    
    init(people: PeopleDetail) {
        self.initialState = State(people: people)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggle(let indexPath):
            return .just(.toggle(indexPath))
        }
    }
    
    func reduce(state: SectionDetailState, mutation: Mutation) -> SectionDetailState {
        
        var newState = state
        
        switch mutation {
        case .toggle(let indexPath):
            if state.expandedIndexPath == indexPath {
                newState.expandedIndexPath = nil
            } else {
                newState.expandedIndexPath = indexPath
            }
        }
        
        return newState
    }
}
