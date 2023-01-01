//
//  NetworkManager.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 31/12/22.
//

import UIKit

//https://picsum.photos/v2/list?page=1&limit=10

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://picsum.photos/v2"
    
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getObjects(page: Int, limit: Int, completed: @escaping (Result<[Object], ErrorMessage>) -> Void) {
        let endpoint = "https://api.github.com/users/sallen0400/followers?per_page=\(limit)&page=1"
        guard let url = URL(string: endpoint) else {
            completed(.failure(.unableToCompleteRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToCompleteRequest))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let objects = try decoder.decode([Object].self, from: data)
                completed(.success(objects))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    
    func getObjects2(completed: @escaping (Result<[Object2], ErrorMessage>) -> Void) {
        let endpoint = "https://api.letsbuildthatapp.com/appstore/social"
        guard let url = URL(string: endpoint) else {
            completed(.failure(.unableToCompleteRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToCompleteRequest))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let objects = try decoder.decode([Object2].self, from: data)
                completed(.success(objects))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
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
