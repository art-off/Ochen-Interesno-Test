//
//  UIViewController+spiner.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 01.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

// Вью для отсутствия нажатий (другие способы либо устарели, либо странно работают)
fileprivate var contentView: UIView?

extension UIViewController {
    
    func showSpiner() {
        contentView = UIView(frame: view.bounds)
        guard let contentView = contentView else { return }
        
        contentView.backgroundColor = .clear
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = contentView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        contentView.addSubview(activityIndicator)
        view.addSubview(contentView)
    }
    
    func removeSpiner() {
        contentView?.removeFromSuperview()
        contentView = nil
    }
    
}
