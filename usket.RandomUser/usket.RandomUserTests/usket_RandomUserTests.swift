//
//  usket_RandomUserTests.swift
//  usket.RandomUserTests
//
//  Created by 이경후 on 2023/10/13.
//

import XCTest
import RxSwift
import RxTest
@testable import usket_RandomUser

final class usket_RandomUserTests: XCTestCase {
    
    var mainReactor: MainReactor?
    var disposeBag: DisposeBag = DisposeBag()
    
    override func setUp() {
        mainReactor = MainReactor()
        let expectation = self.expectation(description: "Initial data load")
        
        // 데이터가 로드된 후에 테스트를 진행할 수 있도록 구독 설정
        mainReactor?.state
            .map { $0.sectionData }
            .distinctUntilChanged()
            .skip(1) // 첫 번째는 초기 값이므로 skip
            .subscribe(onNext: { [weak self] sectionData in
                guard let self = self, sectionData.count > 0 else {
                    return
                }
                
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        mainReactor?.action.onNext(.load(100))
        wait(for: [expectation], timeout: 3.0)
    }
    
    /*
     테스트가 필요한 사항을 정리해보자.
     * 리액터 테스팅
     - Action이 전달되었을 때, 비즈니스 로직을 수행하여 State가 변경되는지 확인하기
     (1) 메인 리액터
     - load: 특정한 카운트 만큼의 데이터를 요청했을 경우, 정상적으로 해당 카운트만큼의 데이터가 들어오고 SectionData가 변경되었는지 확인
     - toSectionDetail: load를 통해 들어온 데이터 중 일부 사람들 데이터를 전달했을 경우, 상태의 pushingViewController가 변경되었는지 or 값이 존재하는지 확인
     - removePushed: pushingViewController의 값이 있는지 확인하고, removePushed 액션을 요청했을 때, 정상적으로 pushingViewController가 nil이 되어있는지 확인하기
     (2) 디테일 리액터
     - toggle(IndexPath): 특정한 IndexPath를 전달했을 경우 ( 해당 IndexPath가 존재할 경우, 없다면 다른 IndexPath를 찾아보기 ), 상태의 expandedIndexPath가 변경되었는지 확인해보기
     */
    
    // MARK: - Test Main Reactor
    
    func testMainReactorLoad() throws {
        let expectation = self.expectation(description: "Section Data is changed")
        var counts = 0
        // 값이 지연되어 들어올 경우, 아래의 비동기 코드는 비효율적이다.
        // DispatchQueue.main.asyncAfter(deadline: .now() + 1) { }
        // 아래의 코드를 사용하자.
        mainReactor?.state
            .map { $0.sectionData }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] sectionData in
                guard let self = self, sectionData.count > 0 else {
                    return
                }
                
                expectation.fulfill()
                
                var values: Set<PersonInfoDetail> = []
                for (_, value) in sectionData {
                    values.formUnion(value)
                }
                
                let totalCount = values.count
                counts = totalCount
            })
            .disposed(by: disposeBag)
        
        // expaectation이 fullfill 되기를 기다렸다가 다음 코드 진행
        // timeout이 지나가면 자동으로 fulfill 처리 되고 진행된다.
        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(counts, 100)
    }
    
    func testMainReactorToSectionDetail() throws {
        let expectation = self.expectation(description: "PushingViewController is changed")
        
        mainReactor?.action.onNext(.toSectionDetail(mainReactor?.currentState.sectionData["20대"] ?? []))
        
        mainReactor?.state
            .map { $0.pushingViewController }
            .subscribe(onNext: { value in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(mainReactor?.currentState.pushingViewController)
    }
    
    func testMainReactorRemovePushed() throws {
        let expectation = self.expectation(description: "PushingViewController is changed")
        mainReactor?.action.onNext(.removePushed)
        
        mainReactor?.state
            .map { $0.pushingViewController }
            .subscribe(onNext: { _ in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNil(mainReactor?.currentState.pushingViewController)
    }
    
    // MARK: - Test DetailReactor
    
    func testDetailReactor() throws {
        let expectation = self.expectation(description: "IndexPath is changed")
        let detailReactor: DetailReactor = DetailReactor(people: mainReactor!.currentState.sectionData["20대"]!)
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        detailReactor.action.onNext(.toggle(indexPath))
        
        detailReactor.state
            .map { $0.expandedIndexPath }
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(detailReactor.currentState.expandedIndexPath)
    }
}
