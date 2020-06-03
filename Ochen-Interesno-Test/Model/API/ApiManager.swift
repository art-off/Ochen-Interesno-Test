//
//  ApiManager.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 01.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

class ApiManager {
    
    static func loadJsonImages(withSearchText searchText: String, complition: @escaping ([ImageResult]?) -> Void) {
        var components = URLComponents(string: API.addres)!
        components.queryItems = [
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "tbm", value: "isch"),
            // для определения страны
            // URLQueryItem(name: "gl", value: "ru"),
            URLQueryItem(name: "api_key", value: API.key)
        ]
        
        URLSession.shared.dataTask(with: components.url!) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode) else {
                    complition(nil)
                    return
            }

            guard let data = data else {
                complition(nil)
                return
            }
            
            do {
                let imagesResponse = try JSONDecoder().decode(ImagesResponse.self, from: data)
                complition(imagesResponse.imagesResults)
            } catch let jsonError {
                print(jsonError)
                complition(nil)
            }
        }.resume()
    }
    
    static func loadImage(urlString: String, complition: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            complition(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                (200...300).contains(httpResponse.statusCode) else {
                    complition(nil)
                    return
            }
            
            guard let data = data else {
                complition(nil)
                return
            }
            
            let image = UIImage(data: data)
            
            complition(image)
        }.resume()
    }
    
}
