//
//  ImagesHelper.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 03.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//
//
//import UIKit
//
//class ImagesHelper {
//    
//    static func getImageFromThumbnail(thumbnail: String, complition: @escaping (UIImage?) -> Void) {
//        
//        // Если в thumbmail был base64, то устанавливаем image
//        if let imageFromBase64 = UIImage.fromBase64(base64: thumbnail) {
//            imageView.image = imageFromBase64
//        // Если в thumbmail не было base64 - пытаемся скачать по ссылке, которая лежит там
//        } else {
//            ImagesManager.shared.loadImage(urlString: thumbnail) { image in
//                DispatchQueue.main.async {
//                    self.imageView.image = image
//                }
//            }
//        }
//        
//    }
//    
//}
