//
//  ActivityIndicator.swift
//  ceiba
//
//  Created by William Lopez on 11/9/21.
//

import UIKit
//import RxSwift

public class CustomLoaderView {
    
    private var parentView: UIView?
    private var loaderView = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    
    class var shared: CustomLoaderView {
        struct Static {
            static let instance: CustomLoaderView = CustomLoaderView()
        }
        return Static.instance
    }
    
    ///To configure the view where the loader will appear
    ///- Parameter view: The parent view of the loader
    func config( view: UIView ) {
        self.parentView = view
    }
    
    func showLoader() {
        hideLoader()
        loaderView = UIView(frame: parentView?.bounds ?? .zero)
        loaderView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loaderView.center
        loaderView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        parentView?.addSubview(loaderView)
    }
    
    func hideLoader() {
        activityIndicator.stopAnimating()
        loaderView.removeFromSuperview()
    }
    
}

