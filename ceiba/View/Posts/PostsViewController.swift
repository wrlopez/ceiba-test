//
//  PostsViewController.swift
//  ceiba
//
//  Created by William Lopez on 11/9/21.
//

import UIKit
import RxSwift
import RxCocoa

class PostsViewController: UIViewController {
    
    @IBOutlet var postsTableView: UITableView!
    
    private var postList: [PostCellViewModel] = []
    private let vieWModel = PostsViewModel()
    private let disposeBag = DisposeBag()
    
    var userId: Int?
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "\(name ?? "User")'s posts"
        
        CustomLoaderView.shared.config(view: view)
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let id = userId, id > 0 {
            vieWModel.getPosts(userId: id)
        }
    }
    
    private func bindViewModel() {
        
        vieWModel.output.isAnimating.drive(CustomLoaderView.shared.rx.isAnimating).disposed(by: disposeBag)
        
        vieWModel.output.postList.drive(
            onNext: {
                [weak self] list in
                guard let self = self else { return }
                self.postList = list
                self.postsTableView.reloadData()
            }
        ).disposed(by: disposeBag)
    }
    
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostTableViewCell.self), for: indexPath) as! PostTableViewCell
        
        cell.configure(with: postList[indexPath.row])
        
        return cell
    }
    
}
