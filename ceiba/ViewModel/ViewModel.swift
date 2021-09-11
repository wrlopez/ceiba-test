//
//  ViewModel.swift
//  ceiba
//
//  Created by William Lopez on 10/9/21.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel: BaseViewModelProtocol {
    
    struct Output {
        let userList: Driver<[UserViewModel]>
    }
    
    let output: Output
    var error: PublishSubject<String> = PublishSubject()
    
    private let userListSubject = BehaviorRelay<[UserViewModel]>(value: [])
    
    init() {
        
        let list = userListSubject.asDriver(onErrorJustReturn: [])
        
        output = Output( userList: list )
    }
    
    func getUsers() {
        let networkProvider = NetworkProvider()
        networkProvider.request(type: [User].self, service: UserService.getUsers) { result in
            switch result {
            case .success(let users):
                let list = users.map{ UserViewModel(user: $0)}
                self.userListSubject.accept(list)
            case .failure(let error):
                self.error.onNext(error.rawValue)
            }
        }
    }
}
