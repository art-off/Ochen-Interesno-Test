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
    
    // Номер страницы со страницами (api возвращает по 100 изображений)
    private var currSearchNumber = 0
    private var searchText: String?
    
    // MARK: - Privates
    private var imagesResults = [ImageResult]()
    
    private let viewWithLabel = WrapperViewWithLabel()
    private let alertView = AlertView()
    
    private var task: URLSessionDataTask?
    
    
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
    
}


// MARK: - Helpers View
extension ImagesCollectionViewController {
    
    // MARK: Show View With Label
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
    
    // MARK: Show Alert View
    private func showAlertView(withText text: String) {
        if !view.subviews.contains(alertView) {
            view.addSubview(alertView)
            
            alertView.translatesAutoresizingMaskIntoConstraints = false
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
           
        alertView.alertLabel.text = text
           
        alertView.alpha = 1.0
        alertView.isHidden = false
           
        alertView.hideWithAnimation()
    }
    
}


// MARK: - Load Images
extension ImagesCollectionViewController {
    
    private func loadImage(searchText: String, searchNumber: Int) {
        task = ApiManager.loadJsonImagesTask(withSearchText: searchText, searchNumber: searchNumber) { imagesResults in
            guard let imagesResults = imagesResults else {
                DispatchQueue.main.async {
                    if self.currSearchNumber == 0 {
                        self.showViewWithLabel(text: "Что-то пошло не так")
                        self.task = nil
                    }
                    self.removeSpiner()
                }
                return
            }
            
            if self.currSearchNumber == 0 {
                self.imagesResults = imagesResults
            } else {
                self.imagesResults += imagesResults
            }
            
            DispatchQueue.main.async {
                self.removeSpiner()
                self.collectionView.reloadData()
                self.currSearchNumber += 1
                self.task = nil
            }
        }
        task?.resume()
    }
    
}


// MARK: - Text Field Delegate
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


// MARK: - Scroll View Delegate
extension ImagesCollectionViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Когда долистываю до низа - докачиваем следующие 100 картинок
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height - 200)) {
            guard let searchText = searchText, task == nil else { return }

            loadImage(searchText: searchText, searchNumber: currSearchNumber)
        }
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
