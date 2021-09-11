//
//  Protocols.swift
//  ceiba
//
//  Created by William Lopez on 10/9/21.
//

import Foundation
import RxSwift

protocol BaseViewModelProtocol {
    
    associatedtype Output
    
    var output: Output { get }
    var error: PublishSubject<String> { get }
}

protocol CellButtonSelectedDelegate: AnyObject {
    func selectCellButton(at indexPath: IndexPath?)
}
