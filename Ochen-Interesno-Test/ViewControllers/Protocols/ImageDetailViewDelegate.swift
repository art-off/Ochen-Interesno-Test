//
//  ImageDetailViewDelegate.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 03.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import Foundation

protocol ImageDetailViewProtocol {
    
    func nextImage(from index: Int) -> (index: Int, info: ImageResult)?
    func previousImage(from index: Int) -> (index: Int, info: ImageResult)?
    
}
