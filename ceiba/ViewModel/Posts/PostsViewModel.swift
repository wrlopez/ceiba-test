//
//  PostsViewModel.swift
//  ceiba
//
//  Created by William Lopez on 11/9/21.
//

import Foundation
import RxSwift
import RxCocoa

class PostsViewModel: BaseViewModelProtocol {
    
    struct Output {
        let postList: Driver<[PostCellViewModel]>
        let isAnimating: Driver<Bool>
    }
    
    let output: Output
    var error: PublishSubject<String> = PublishSubject()
    
    private let postListSubject = BehaviorRelay<[PostCellViewModel]>(value: [])
    private let isAnimatingSubject = PublishSubject<Bool>()
    
    init() {
        
        let list = postListSubject.asDriver(onErrorJustReturn: [])
        let isAnimating = isAnimatingSubject.asDriver(onErrorJustReturn: false)
        
        output = Output(postList: list, isAnimating: isAnimating)
    }
    
    func getPosts( userId: Int ) {
        
        let networkProvider = NetworkProvider()
        isAnimatingSubject.onNext(true)
        networkProvider.request(type: [Post].self, service: PostService.getPosts(id: userId)) { result in
            
            switch result {
            case .success(let posts):
                let list = posts.map{ PostCellViewModel(post: $0)}
                self.isAnimatingSubject.onNext(false)
                self.postListSubject.accept(list)
            case .failure(let error):
                self.isAnimatingSubject.onNext(false)
                self.error.onNext(error.rawValue)
            }
        }
    }
}
