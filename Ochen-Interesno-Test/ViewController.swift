//
//  ViewController.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 31.05.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // закрытие клавиатуры по нажатию вне ее
        addTapGestureToHideKeyboard()
        
        navigationItem.title = "Поиск изображений"
        
        searchTextField.delegate = self
    }

}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text else { return false }
        guard !searchText.isEmpty else { return false }
        
        showSpiner()
        view.endEditing(true)
        
        ApiManager.downloadJsonImages(withSearchText: searchText) { imagesResults in
            
            print(imagesResults![5])
        
            if let thumbnail = imagesResults![5].thumbnail {
                let base64 = thumbnail
                
                let correctBase64 = String(base64.suffix(from: base64.index(base64.firstIndex(of: ",")!, offsetBy: 1)))
                
                let imageData = Data(base64Encoded: correctBase64)!
                let image = UIImage(data: imageData)
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            
            DispatchQueue.main.async {
                self.removeSpiner()
            }
        }
        
        return true
    }
    
}
