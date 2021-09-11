//
//  UserViewModel.swift
//  ceiba
//
//  Created by William Lopez on 10/9/21.
//

import Foundation
import RxSwift
import RxCocoa

class UserViewModel: BaseViewModelProtocol {
    
    struct Output {
        let name: Driver<String>
        let phone: Driver<String>
        let email: Driver<String>
    }
    
    let output: Output
    let error: PublishSubject<String> = PublishSubject()
    private var user: User?
    private let nameSubject = ReplaySubject<String>.create(bufferSize: 1)
    private let phoneSubject = ReplaySubject<String>.create(bufferSize: 1)
    private let emailSubject = ReplaySubject<String>.create(bufferSize: 1)
    
    init( user: User ) {
        
        self.user = user
        
        let name = nameSubject.asDriver(onErrorJustReturn: "")
        let phone = phoneSubject.asDriver(onErrorJustReturn: "")
        let email = emailSubject.asDriver(onErrorJustReturn: "")
        
        output = Output( name: name, phone: phone, email: email)
        
        initSubject()
    }
    
    private func initSubject() {
        if let user = user {
            nameSubject.onNext(user.name ?? "")
            phoneSubject.onNext(user.phone ?? "")
            emailSubject.onNext(user.email ?? "")
        }
    }
}
