//
//  MainReactor.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/10/17.
//

import UIKit
import ReactorKit

final class MainReactor: Reactor {
    
    typealias State = MainState
    
    enum Action {
        case load(Int)
        case toSectionDetail(PeopleDetail)
        case removePushed
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setPeople(PeopleDetail)
        case toSectionDetail(PeopleDetail)
        case removePushed
    }
    
    struct MainState {
        var isLoading: Bool = false
        var sectionTitles: [String] = ["남성", "여성", "20대", "30대"]
        var sectionData: [String: PeopleDetail] = [:]
        var pushingViewController: UIViewController?
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load(let count):
            return RandomUserService.shared.fetchRandomUsers(count: count)
                .map { .setPeople($0) }
                .startWith(.setLoading(true))
        case .toSectionDetail(let people):
            return .just(.toSectionDetail(people))
        case .removePushed:
            return .just(.removePushed)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> MainState {
        
        var newState = state
        
        switch mutation {
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setPeople(let people):
            newState.isLoading = false
            newState.sectionData = groupPeopleBySections(people)
        case .toSectionDetail(let people):
            let viewController = createDetailViewController(people)
            newState.pushingViewController = viewController
        case .removePushed:
            newState.pushingViewController = nil
        }
        
        return newState
    }
    
    private func groupPeopleBySections(_ people: PeopleDetail) -> [String: PeopleDetail] {
        var sectionData: [String: PeopleDetail] = [:]
        
        sectionData["남성"] = people.filter { $0.gender }
        sectionData["여성"] = people.filter { !$0.gender }
        sectionData["20대"] = people.filter { $0.age > 19 && $0.age < 30 }
        sectionData["30대"] = people.filter { $0.age > 29 && $0.age < 40 }
        
        return sectionData
    }
    
    private func createDetailViewController(_ detail: PeopleDetail) -> DetailViewController {
        let viewController = DetailViewController()
        viewController.reactor = DetailReactor(people: detail)
        return viewController
    }
}
