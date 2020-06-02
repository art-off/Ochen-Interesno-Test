//
//  ViewController.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 31.05.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 12.0, bottom: 20.0, right: 12.0)
    private let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Поиск изображений"
        
        // Отступаем от top на величину высоты searchTextField и 8 отступ сверху и 8 сниху
        collectionView.contentInset = UIEdgeInsets(top: searchTextField.frame.height + 2 * 8, left: 0, bottom: 0, right: 0)
        
        searchTextField.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        // collectionView.delegate = self
        
        // закрытие клавиатуры по нажатию вне ее
        addTapGestureToHideKeyboard()
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
                
//                DispatchQueue.main.async {
//                    self.imageView.image = image
//                }
            }
            
            DispatchQueue.main.async {
                self.removeSpiner()
            }
        }
        
        return true
    }
    
}

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        //cell.label.text = String(indexPath.row)
        cell.contentView.backgroundColor = .green
        return cell
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let avaialableWidth = view.frame.width - paddingSpace
        let widhtPerItem = avaialableWidth / itemsPerRow

        return CGSize(width: widhtPerItem, height: widhtPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

}
