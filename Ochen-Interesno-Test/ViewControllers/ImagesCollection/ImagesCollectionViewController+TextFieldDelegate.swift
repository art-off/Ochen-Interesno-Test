//
//  ImagesCollectionViewController+TextFieldDelegate.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 06.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

extension ImagesCollectionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        guard !text.isEmpty else { return false }
        
        searchText = text
        currSearchNumber = 0
        
        // Убираем надпись 'Введите поисковый запрос'
        viewWithLabel.isHidden = true
        
        textField.textAlignment = .center
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        showSpiner()
        view.endEditing(true)
        
        loadImage(searchText: searchText!, searchNumber: currSearchNumber)
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.textAlignment = .left
        textField.font = UIFont(name: "System", size: 15)
        return true
    }
    
}
