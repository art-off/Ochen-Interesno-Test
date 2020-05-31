//
//  ViewController.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 31.05.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ApiManager.downloadJsonImages(withSearchText: "ojo") { imagesResults in
            
            let base64 = imagesResults![5].thumbnail!
            
            let correctBase64 = String(base64.suffix(from: base64.index(base64.firstIndex(of: ",")!, offsetBy: 1)))

            let imageData = Data(base64Encoded: correctBase64)!
            let image = UIImage(data: imageData)

//            for i in 0..<100 {
//                print(imagesResults![i])
//            }
            
            print(imagesResults![55])
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
            
            
            
        }

        
    }


}

