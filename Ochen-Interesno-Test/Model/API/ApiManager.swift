//
//  ApiManager.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 01.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit

class ApiManager {
    
    static func loadJsonImagesTask(withSearchText searchText: String, searchNumber: Int, complition: @escaping ([ImageResult]?) -> Void) -> URLSessionDataTask? {
        guard var components = URLComponents(string: API.addres) else {
            complition(nil)
            return nil
        }
        components.queryItems = [
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "tbm", value: "isch"),
            // для определения страны
            // URLQueryItem(name: "gl", value: "ru"),
            URLQueryItem(name: "ijn", value: String(searchNumber)),
            URLQueryItem(name: "api_key", value: API.key)
        ]
        
        let task = URLSession.shared.dataTask(with: components.url!) { data, response, error in
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
        }
        
        return task
    }
    
    static func loadImageTask(urlString: String, complition: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            complition(nil)
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
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
        }
        
        return task
    }
    
}
