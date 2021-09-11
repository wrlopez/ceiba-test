//
//  UserTableViewCell.swift
//  ceiba
//
//  Created by William Lopez on 10/9/21.
//

import UIKit
import RxSwift
import RxCocoa

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    private var index: IndexPath?
    weak var delegate: CellButtonSelectedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure( with viewModel: UserCellViewModel, at index: IndexPath ) {
        viewModel.output.name.drive(nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.email.drive(emailLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.phone.drive(phoneLabel.rx.text).disposed(by: disposeBag)
        
        self.index = index
    }
    
    @IBAction func viewPosts(_ sender: UIButton) {
        delegate?.selectCellButton(at: index)
    }
    
}
