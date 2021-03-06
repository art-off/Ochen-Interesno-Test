//
//  ImageDetailViewController+UI.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 06.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

extension ImageDetailViewController {
    
    // MARK: Show View With Label
    func showViewWithLabel(withText text: String) {
        if !view.subviews.contains(viewWithLabel) {
            view.addSubview(viewWithLabel)
            viewWithLabel.translatesAutoresizingMaskIntoConstraints = false
            viewWithLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            viewWithLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            viewWithLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            viewWithLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6 * 8).isActive = true
        }
        
        viewWithLabel.label.text = text
        viewWithLabel.isHidden = false
    }
    
    // MARK: Show Alert View
    func showAlertView(withText text: String) {
        if !view.subviews.contains(alertView) {
            view.addSubview(alertView)

            alertView.translatesAutoresizingMaskIntoConstraints = false
            alertView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
            alertView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        }
        
        alertView.alertLabel.text = text
        
        alertView.alpha = 1.0
        alertView.isHidden = false
        
        alertView.hideWithAnimation()
    }
    
}
