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
    
    // MARK: - Для Collection View
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 12.0, bottom: 20.0, right: 12.0)
    private let itemsPerRow: CGFloat = 3
    
    // MARK: - Privates
    private var imagesResults = [ImageResult]()
    
    
    // MARK: - Ovverides
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

// MARK: - Text Field Delegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text else { return false }
        guard !searchText.isEmpty else { return false }
        
        showSpiner()
        view.endEditing(true)
        
        ApiManager.loadJsonImages(withSearchText: searchText) { imagesResults in
            guard let imagesResults = imagesResults else {
                // Написать что-нибудь еще
                DispatchQueue.main.async {
                    self.removeSpiner()
                }
                return
            }
            
            self.imagesResults = imagesResults
            
            DispatchQueue.main.async {
                self.removeSpiner()
                print(self.imagesResults)
                self.collectionView.reloadData()
            }
        }
        
        return true
    }
    
}

// MARK: - Collection View Data Source
extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        // чтобы фото не повторялись
        cell.imageView.image = nil
        cell.imageInfo = imagesResults[indexPath.row]
        cell.setImage()
        return cell
    }

}

// MARK: - Collection View Delegate Flow Layout
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
