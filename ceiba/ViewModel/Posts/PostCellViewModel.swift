//
//  PostCellViewModel.swift
//  ceiba
//
//  Created by William Lopez on 11/9/21.
//

import Foundation
import RxSwift
import RxCocoa

class PostCellViewModel: BaseViewModelProtocol {
    
    struct Output {
        let title: Driver<String>
        let body: Driver<String>
    }
    
    let output: Output
    let error: PublishSubject<String> = PublishSubject()
    private var post: Post?
    private let titleSubject = ReplaySubject<String>.create(bufferSize: 1)
    private let bodySubject = ReplaySubject<String>.create(bufferSize: 1)
    
    init( post: Post ) {
        self.post = post
        
        let title = titleSubject.asDriver(onErrorJustReturn: "")
        let body = bodySubject.asDriver(onErrorJustReturn: "")
        
        output = Output(title: title, body: body)
        
        initSubjects()
    }
    
    private func initSubjects() {
        if let post = post {
            titleSubject.onNext(post.title ?? "")
            bodySubject.onNext(post.body ?? "")
        }
    }
}
