//
//  UIImage+base64.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 02.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func fromBase64(base64: String) -> UIImage? {
        let correctBase64: String
        // первые 8-9 символов (до ",") не нужны для раскодирования
        if base64.contains(",") {
            correctBase64 = String(base64.suffix(from: base64.index(base64.firstIndex(of: ",")!, offsetBy: 1)))
        } else {
            correctBase64 = base64
        }
        
        if let imageData = Data(base64Encoded: correctBase64) {
            let image = UIImage(data: imageData)
            return image
        }
        
        return nil
    }
    
}
