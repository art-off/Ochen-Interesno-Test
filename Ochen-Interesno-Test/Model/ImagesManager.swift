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
    
    
    func loadImage(urlString: String, complition: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        // Если изображение есть в кэш - возвращаем его
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            complition(imageFromCache)
            return nil
        }
        
        // Если нет - качаем и записываем в кэш
        let task = ApiManager.loadImageTask(urlString: urlString) { image in
            guard let image = image else {
                complition(nil)
                return
            }
            
            self.imageCache.setObject(image, forKey: urlString as NSString)
            complition(image)
        }
        
        if let task = task {
            return task
        } else {
            complition(nil)
            return nil
        }
    }
    
}
