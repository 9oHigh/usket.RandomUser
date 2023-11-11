//
//  UIImageView+Extension.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/10/18.
//

import UIKit

extension UIImageView {
    
    private static var imageCache = NSCache<NSString, UIImage>()
    
    func loadImageFromUrl(url: URL?, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        guard let url = url else {
            return
        }
        
        if let cachedImage = UIImageView.imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    UIImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    self?.image = image
                }
            }
        }.resume()
    }
}
