//
//  ImagesCollectionViewController+ScrollViewDelegate.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 06.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

extension ImagesCollectionViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Когда долистываю до низа - докачиваем следующие 100 картинок
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height - 200)) {
            guard let searchText = searchText, task == nil else { return }

            loadImage(searchText: searchText, searchNumber: currSearchNumber)
        }
    }
    
}
