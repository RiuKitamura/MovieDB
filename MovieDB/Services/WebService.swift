//
//  WebService.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import UIKit

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

struct Resource<T> {
    let url: URL
    let parse: (Data) -> T?
}

final class WebService {
    
    func loadMovie<T>(resource: Resource<T>, completion: @escaping(Result<T?, NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: resource.url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(.domainError))
                    return
                }
                
                completion(.success(resource.parse(data)))
            }
        }.resume()
    }
    
    
    func downloadImage(with link: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        guard let url = URL(string: link) else {
            completion(.failure(.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.domainError))
                }
                return
            }
            
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
            
        }.resume()
        
    }
}
