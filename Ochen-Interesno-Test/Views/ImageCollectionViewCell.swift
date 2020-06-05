//
//  ImageCollectionViewCell.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 01.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    var imageInfo: ImageResult!
    
    private var task: URLSessionDataTask!
    
    
    // MARK: - Methods
    func setImage() {
        // Если миниизображение есть (base64 или ссылка)
        if let thumbnail = imageInfo.thumbnail {
            // Если в thumbmail был base64, то устанавливаем image
            if let imageFromBase64 = UIImage.fromBase64(base64: thumbnail) {
                imageView.image = imageFromBase64
            // Если в thumbmail не было base64 - пытаемся скачать по ссылке, которая лежит там
            } else {
                // Если есть в кэше - берем оттуда
                if let thumbnailFromCache = ImagesManager.shared.getCachedImage(urlString: thumbnail) {
                    self.imageView.image = thumbnailFromCache
                    return
                }
                
                // Иначе качаем
                task = ImagesManager.shared.loadImage(urlString: thumbnail) { image in
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
                task?.resume()
            }
        // Если соовсем нет thumbmail - загружаем в качетсве мини-изображения original
        } else if let original = imageInfo.original {
            task = ImagesManager.shared.loadImage(urlString: original) { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            task?.resume()
        }
    }
    
    func cancelTask() {
        task?.cancel()
    }
    
}
