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
    
    
    // MARK: - Для Search Controller
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Поиск изображений"
        
        setupSearchController()
        
        
        ApiManager.downloadJsonImages(withSearchText: "mojong") { imagesResults in
            
            let base64 = imagesResults![5].thumbnail!
            
            let correctBase64 = String(base64.suffix(from: base64.index(base64.firstIndex(of: ",")!, offsetBy: 1)))

            let imageData = Data(base64Encoded: correctBase64)!
            let image = UIImage(data: imageData)

//            for i in 0..<100 {
//                print(imagesResults![i])
//            }
            
            print(imagesResults![55])
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Введите название изображения"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // чтобы строка поиска всегда отображался
        navigationItem.hidesSearchBarWhenScrolling = false
    }


}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        print("searchd")
    }
    
}
