//
//  UIImageView+Extension.swift
//  usket.RandomUser
//
//  Created by 이경후 on 2023/10/18.
//

import UIKit

extension UIImageView {
    
    func loadImageFromUrl(url: URL?) {
        
        guard let url = url else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
