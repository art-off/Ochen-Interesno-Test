//
//  ImagesCollectionViewController+ImageDetailViewProtocol.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 06.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

extension ImagesCollectionViewController: ImageDetailViewProtocol {
    
    func nextImage(from index: Int) -> (index: Int, info: ImageResult)? {
        guard index >= 0 && index < imagesResults.count - 1 else {
            guard let searchText = searchText, task == nil else { return nil }
            loadImage(searchText: searchText, searchNumber: currSearchNumber)
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
