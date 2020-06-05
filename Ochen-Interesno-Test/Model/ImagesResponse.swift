//
//  ImagesResponse.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 31.05.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import Foundation

struct ImagesResponse: Codable {
    
    let imagesResults: [ImageResult]
    
    enum CodingKeys: String, CodingKey {
        case imagesResults = "images_results"
    }
    
}

struct ImageResult: Codable {
    
    let position: Int
    let thumbnail: String?
    let original: String?
    let source: String?
    let title: String?
    let link: String?
    
}
