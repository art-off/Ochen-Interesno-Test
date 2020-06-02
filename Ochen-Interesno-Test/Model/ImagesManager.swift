//
//  ImagesManager.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 02.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

class ImagesManager {
    
    static let shared = ImagesManager()
    
    var imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(urlString: String, complition: @escaping (UIImage?) -> Void) {
        // Если изображение есть в кэш - возвращаем его
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            complition(imageFromCache)
            return
        }
        
        // Если нет - качаем и записываем в кэш
        ApiManager.loadImage(urlString: urlString) { image in
            guard let image = image else {
                complition(nil)
                return
            }
            
            self.imageCache.setObject(image, forKey: urlString as NSString)
            complition(image)
        }
        
    }
    
}