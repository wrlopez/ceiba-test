//
//  ceibaTests.swift
//  ceibaTests
//
//  Created by William Lopez on 11/9/21.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import ceiba

class ceibaTests: XCTestCase {
    
    var viewModel: ViewModel!
    var disposeBag: DisposeBag!
    var testScheduler: TestScheduler!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = ViewModel()
        disposeBag = DisposeBag()
        testScheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        disposeBag = nil
        testScheduler = nil
        try super.tearDownWithError()
    }
    
    func testUserListIsEmpty() throws {
        XCTAssertEqual(try viewModel.output.userList.toBlocking().first()?.count, 0)
    }
    
    func testUserListIsPopulated() {
        let user = User()
        user.id = 1
        user.name = "William"
        
        let user2 = User()
        user2.id = 2
        user2.name = "Raul"
        
        let userList = [UserCellViewModel(user: user), UserCellViewModel(user: user2)]
        
        let listObserver = testScheduler.createObserver([UserCellViewModel].self)
        
        viewModel.originalUserList = userList
        viewModel.output.userList.drive(listObserver).disposed(by: disposeBag)
        
        testScheduler.createColdObservable([.next(10, userList)])
            .bind(to: viewModel.userListSubject).disposed(by: disposeBag)
        
        testScheduler.start()
        
        XCTAssertEqual(listObserver.events, [
            .next(0, []),
            .next(10, userList)
        ])
    }
    
    func testUsersAreFiltered() {
        let user = User()
        user.id = 1
        user.name = "William"
        
        let user2 = User()
        user2.id = 2
        user2.name = "Raul"
        
        let userList = [UserCellViewModel(user: user), UserCellViewModel(user: user2)]
        let filteredList = [UserCellViewModel(user: user)]
        let listObserver = testScheduler.createObserver([UserCellViewModel].self)
        
        viewModel.originalUserList = userList
        viewModel.output.userList.drive(listObserver).disposed(by: disposeBag)
        
        viewModel.filterUsers(text: "William")
        
        testScheduler.start()
        
        XCTAssertEqual(listObserver.events, [
            .next(0, []),
            .next(0, filteredList)
        ])
    }
    
}
