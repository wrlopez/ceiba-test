//
//  ViewController.swift
//  ceiba
//
//  Created by William Lopez on 10/9/21.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet var usersTableView: UITableView!
    
    private var userList: [UserViewModel] = []
    private let viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.keyboardDismissMode = .onDrag
        
        bindViewModel()
        
        viewModel.getUsers()
    }
    
    private func bindViewModel() {
        viewModel.output.userList.drive(
            onNext: { [weak self] (list) in
                guard let self = self else { return }
                self.userList = list
                self.usersTableView.reloadData()
            }
        ).disposed(by: disposeBag)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserTableViewCell.self), for: indexPath) as! UserTableViewCell
        
        cell.configure(with: userList[indexPath.row], at: indexPath)
        cell.delegate = self
        
        return cell
    }
    
}

extension ViewController: CellButtonSelectedDelegate {
    func selectCellButton(at indexPath: IndexPath?) {
    
    }
}
