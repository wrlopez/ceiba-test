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
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var placeholderLabel: UILabel!
    
    private var userList: [UserCellViewModel] = []
    private let viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.keyboardDismissMode = .onDrag
        usersTableView.rowHeight = UITableView.automaticDimension
        usersTableView.estimatedRowHeight = 200
        usersTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        
        searchBar.delegate = self
        
        CustomLoaderView.shared.config(view: view)
        
        bindViewModel()
        
        viewModel.fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func bindViewModel() {
        
        viewModel.output.isAnimating.drive(CustomLoaderView.shared.rx.isAnimating).disposed(by: disposeBag)
        
        viewModel.output.userList.drive(
            onNext: { [weak self] (list) in
                guard let self = self else { return }
                self.placeholderLabel.isHidden = list.count > 0
                self.usersTableView.separatorStyle = list.count > 0 ? .singleLine : .none
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
        if let index = indexPath {
            let id = userList[index.row].getUserId()
            let viewController = storyboard?.instantiateViewController(identifier: String(describing: PostsViewController.self)) as! PostsViewController
            
            viewController.userId = id
            viewController.name = userList[index.row].getName()
                
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterUsers(text: searchText)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.filterUsers(text: "")
        searchBar.resignFirstResponder()
    }
}
