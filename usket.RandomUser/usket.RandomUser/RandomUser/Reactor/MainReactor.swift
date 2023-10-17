//
//  MainReactor.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/10/17.
//

import Foundation
import ReactorKit

final class MainReactor: Reactor {

    typealias State = MainState
    
    enum Action {
        case load(Int)
        case toSectionDetail(People)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setPeople(People)
        case toSectionDetail(People)
    }
    
    struct MainState {
        var people: People = People()
        var isLoading: Bool = false
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load(let count): // 데이터 가지고 오기
            return RandomUserService.shared.fetchRandomUsers(count: count)
                .map { .setPeople($0) }
                .startWith(.setLoading(true))
        case .toSectionDetail(let people): // 상세화면 이동하기 위한 데이터 방출
            return .just(.toSectionDetail(people))
        }
    }
    
    func reduce(state: MainState, mutation: Mutation) -> MainState {
        
        var newState = state
        
        switch mutation {
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setPeople(let people):
            newState.isLoading = false
            newState.people = people
        case .toSectionDetail(_):
            return newState
        }
        
        return newState
    }
}
