//
//  ImagesCollectionViewController.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 31.05.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

class ImagesCollectionViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Для Collection View
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 12.0, bottom: 20.0, right: 12.0)
    private let itemsPerRow: CGFloat = 3
    
    // MARK: - Privates
    private var imagesResults = [ImageResult]()
    
    private let viewWithLabel = WrapperViewWithLabel()
    
    // MARK: - Ovverides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Поиск изображений"
        
        // Отступаем от top на величину высоты searchTextField и 8 отступ сверху и 8 сниху
        collectionView.contentInset = UIEdgeInsets(top: searchTextField.frame.height + 2 * 8, left: 0, bottom: 0, right: 0)
        
        searchTextField.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        showViewWithLabel(text: "Введите поисковый запрос")
    }
    
    
    // MARK: - View With Text To Enter Text
    private func showViewWithLabel(text: String) {
        if !view.subviews.contains(viewWithLabel) {
            view.addSubview(viewWithLabel)
            viewWithLabel.translatesAutoresizingMaskIntoConstraints = false
            viewWithLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 2 * 8).isActive = true
            viewWithLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            viewWithLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            viewWithLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2 * 8).isActive = true
        }
        
        viewWithLabel.label.text = text
        viewWithLabel.isHidden = false
    }
    
}

// MARK: - Text Field Delegate
extension ImagesCollectionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text else { return false }
        guard !searchText.isEmpty else { return false }
        
        // Убираем надпись 'Введите поисковый запрос'
        viewWithLabel.isHidden = true
        
        textField.textAlignment = .center
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        showSpiner()
        view.endEditing(true)
        
        let task = ApiManager.loadJsonImagesTask(withSearchText: searchText) { imagesResults in
            guard let imagesResults = imagesResults else {
                DispatchQueue.main.async {
                    self.showViewWithLabel(text: "Что-то пошло не так")
                    self.removeSpiner()
                }
                return
            }
            
            self.imagesResults = imagesResults
            
            DispatchQueue.main.async {
                self.removeSpiner()
                self.collectionView.reloadData()
            }
        }
        task?.resume()
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.textAlignment = .left
        textField.font = UIFont(name: "System", size: 15)
        return true
    }
    
}

// MARK: - Collection View Data Source
extension ImagesCollectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        cell.imageInfo = imagesResults[indexPath.row]
        cell.setImage()
        
        return cell
    }

}

// MARK: - Collection View Delegate
extension ImagesCollectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let detailVC = ImageDetailViewController()
        detailVC.delegate = self
        detailVC.imageInfo = imagesResults[index]
        detailVC.currIndex = index
        navigationController?.pushViewController(detailVC, animated: true)
    }

}

// MARK: - Collection View Delegate Flow Layout
extension ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {

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

// MARK: - Image Detail View Protocol
extension ImagesCollectionViewController: ImageDetailViewProtocol {
    func nextImage(from index: Int) -> (index: Int, info: ImageResult)? {
        guard index >= 0 && index < imagesResults.count - 1 else {
            return nil
        }
        
        let nextIndex = index + 1
        let imageResult = imagesResults[nextIndex]
        return (nextIndex, imageResult)
    }
    
    func previousImage(from index: Int) -> (index: Int, info: ImageResult)? {
        guard index >= 1 && index < imagesResults.count else {
            return nil
        }
        
        let previousIndex = index - 1
        let imageResult = imagesResults[previousIndex]
        return (previousIndex, imageResult)
    }
    
}
