//
//  CacheImageView.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 02/06/21.
//

import UIKit

let imageChace = NSCache<NSString, UIImage>()

class CacheImageView: UIImageView {

    var imageUrlString: String?
    
    func downloadImage(from link: String) {
        
        self.imageUrlString = link
        
        if let imageFromCache = imageChace.object(forKey: link as NSString) {
            
            self.image = imageFromCache
            return
        }
        
        self.image = UIImage(named: "placeholder_image")
        
        WebService().downloadImage(with: link) {[weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                imageChace.setObject(image, forKey: link as NSString)
                if self.imageUrlString == link {
                    self.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
