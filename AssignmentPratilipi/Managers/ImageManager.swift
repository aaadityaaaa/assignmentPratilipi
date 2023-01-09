//
//  ImageManager.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 10/01/23.
//

import Foundation
import UIKit


class ImageManager {
    
    static let shared = ImageManager()
    let cache = NSCache<NSString, UIImage>()
    private init() {}
    func downloadImageFromUrl(from urlString: String, completed: @escaping (UIImage?) -> Void) {
            
            let cacheKey = NSString(string: urlString)

            if let image = cache.object(forKey: cacheKey) {
                    completed(image)
                
                return
            }
            guard let url = URL(string: urlString) else {
                completed(nil)
                print("IMAGE DOWNLOAD LINK FOUND NIL")
                return}
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self,
                      error == nil,
                      let response = response as? HTTPURLResponse,
                      let data = data,
                      let image = UIImage(data: data)
                      else {
                    print("IMAGE DOWNLOAD LINK FOUND NIL")
                    completed(nil)
                    return }
                self.cache.setObject(image, forKey: cacheKey)
                completed(image)
            }
            task.resume()
    }
    
}
