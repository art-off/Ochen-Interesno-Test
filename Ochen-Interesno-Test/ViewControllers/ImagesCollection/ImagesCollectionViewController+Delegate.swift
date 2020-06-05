//
//  ImagesCollectionViewController+Delegate.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 06.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

extension ImagesCollectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let detailVC = ImageDetailViewController()
        detailVC.delegate = self
        detailVC.imageInfo = imagesResults[index]
        detailVC.currIndex = index
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // FIXME: Не проходит guard
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Вот эта проверка не проходит
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell else { return }
        
        cell.imageInfo = imagesResults[indexPath.row]
        cell.setImage()
    }

}
