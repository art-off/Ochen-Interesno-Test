//
//  ImagesCollectionViewController+LoadImages.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 06.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

extension ImagesCollectionViewController {
    
    func loadImage(searchText: String, searchNumber: Int) {
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
