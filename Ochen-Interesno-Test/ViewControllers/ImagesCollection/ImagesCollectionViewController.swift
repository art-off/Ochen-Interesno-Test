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
    
    // MARK: View для предупреждения
    let viewWithLabel = WrapperViewWithLabel()
    let alertView = AlertView()
    
    // MARK: Для Collection View Flow Layout
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 12.0, bottom: 20.0, right: 12.0)
    let itemsPerRow: CGFloat = 3
    
    // MARK: Для поиска
    // Номер страницы со страницами (api возвращает по 100 изображений)
    var currSearchNumber = 0
    var searchText: String?
    
    // MARK: task для скачивания изображений
    var task: URLSessionDataTask?
    
    // MARK: Data Source для Collection View
    var imagesResults = [ImageResult]()
    
    
    // MARK: - Ovverides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Поиск изображений"
        
        // Отступаем от top на величину высоты searchTextField и 8 отступ сверху и 8 сниху
        collectionView.contentInset = UIEdgeInsets(top: searchTextField.frame.height + 2 * 8, left: 0, bottom: 0, right: 0)
        
        searchTextField.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        showViewWithLabel(withText: "Введите поисковый запрос")
    }
    
}
