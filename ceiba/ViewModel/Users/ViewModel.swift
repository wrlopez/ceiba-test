//
//  ViewModel.swift
//  ceiba
//
//  Created by William Lopez on 10/9/21.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class ViewModel: BaseViewModelProtocol {
    
    struct Output {
        let userList: Driver<[UserCellViewModel]>
        let isAnimating: Driver<Bool>
    }
    
    let output: Output
    var error: PublishSubject<String> = PublishSubject()
    
    private var originalUserList: [UserCellViewModel]
    private let userListSubject = BehaviorRelay<[UserCellViewModel]>(value: [])
    private let isAnimatingSubject = PublishSubject<Bool>()
    
    init() {
        originalUserList = []
        
        let list = userListSubject.asDriver(onErrorJustReturn: [])
        let isAnimating = isAnimatingSubject.asDriver(onErrorJustReturn: false)
        
        output = Output( userList: list, isAnimating: isAnimating )
    }
    
    private func getUsers() {
        
        let networkProvider = NetworkProvider()
        isAnimatingSubject.onNext(true)
        networkProvider.request(type: [User].self, service: UserService.getUsers) { result in
            switch result {
            case .success(let users):
                let list = users.map{ UserCellViewModel(user: $0)}
                self.originalUserList = list
                self.saveToCoreData(list: users)
                self.isAnimatingSubject.onNext(false)
                self.userListSubject.accept(list)
            case .failure(let error):
                self.isAnimatingSubject.onNext(false)
                self.error.onNext(error.rawValue)
            }
        }
    }
    
    func filterUsers( text: String ) {
        let list = text.isEmpty ? originalUserList : originalUserList.filter({
            $0.getName().range(of: text, options: .caseInsensitive) != nil
        })
        
        userListSubject.accept(list)
    }
    
    private func saveToCoreData( list: [User] ) {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            list.forEach { user in
                if let entity = NSEntityDescription.entity(forEntityName: "UserEntity", in: managedContext) {
                    let userEntity = NSManagedObject(entity: entity, insertInto: managedContext)
                    userEntity.setValue(user.id, forKey: "id")
                    userEntity.setValue(user.name, forKey: "name")
                    userEntity.setValue(user.phone, forKey: "phone")
                    userEntity.setValue(user.email, forKey: "email")
                    
                    do {
                        try managedContext.save()
                    } catch {
                        print("Error saving data", error.localizedDescription)
                    }
                }
            }
        }
        
    }
    
    func fetchUsers() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")
        
        do {
            let list = try managedContext.fetch(fetchRequest)
            if list.count > 0 {
                let userList = list.map { userEntity -> User in
                    let user = User()
                    user.id = userEntity.value(forKey: "id") as? Int ?? 0
                    user.name = userEntity.value(forKey: "name") as? String
                    user.phone = userEntity.value(forKey: "phone") as? String
                    user.email = userEntity.value(forKey: "email") as? String

                    return user
                }.map{ UserCellViewModel(user: $0)}
                
                originalUserList = userList
                userListSubject.accept(userList)
            } else {
                getUsers()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            getUsers()
        }
    }
}
