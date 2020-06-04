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
    
    
    func getCachedImage(urlString: String) -> UIImage? {
        guard let imageFromCache = imageCache.object(forKey: urlString as NSString) else {
            return nil
        }
        
        return imageFromCache
    }
    
    func loadImage(urlString: String, complition: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
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
