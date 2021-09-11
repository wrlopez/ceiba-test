//
//  PostTableViewCell.swift
//  ceiba
//
//  Created by William Lopez on 11/9/21.
//

import UIKit
import RxSwift
import RxCocoa

class PostTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure( with viewModel: PostCellViewModel ) {
        viewModel.output.title.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.body.drive(bodyLabel.rx.text).disposed(by: disposeBag)
    }

}
