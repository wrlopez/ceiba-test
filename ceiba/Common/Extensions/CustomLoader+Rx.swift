//
//  CustomLoader+Rx.swift
//  ceiba
//
//  Created by William Lopez on 11/9/21.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: CustomLoaderView {
    
    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { (indicator, active) in
            active ? indicator.showLoader() : indicator.hideLoader()
        }
    }
}

extension CustomLoaderView: ReactiveCompatible {}
