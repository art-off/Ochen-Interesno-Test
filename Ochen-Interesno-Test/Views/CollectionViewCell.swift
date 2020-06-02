//
//  CollectionViewCell.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 01.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var imageInfo: ImageResult!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    func setImage() {
        // Если миниизображение есть (base64 или ссылка)
        if let thumbmail = imageInfo.thumbnail {
            
            let imageFromBase64 = UIImage.fromBase64(base64: thumbmail)
            
            // Если в thumbmail был base64, то устанавливаем image
            if let imageFromBase64 = imageFromBase64 {
                imageView.image = imageFromBase64
            // Если в thumbmail не было base64 - пытаемся скачать по ссылке, которая лежит там
            } else {
                ImagesManager.shared.loadImage(urlString: thumbmail) { image in
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        // Если соовсем нет thumbmail - загружаем в качетсве мини-изображения original
        } else {
            ImagesManager.shared.loadImage(urlString: imageInfo.original) { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    
}
