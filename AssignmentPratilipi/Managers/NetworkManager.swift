//
//  NetworkManager.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 31/12/22.
//

import UIKit

protocol ObjectService {
    
    func getObjects(limit: Int, completed: @escaping (Result<[Object], ErrorMessage>) -> Void)
    
    func getObjects2(completed: @escaping (Result<[Object2], ErrorMessage>) -> Void)
    
    func getObjectsAsync(limit: Int) async throws -> [Object]
    
    func getObjects2Async() async throws -> [Object2]
    
}


class NetworkManager: ObjectService {
    //old methods to fetch
    func getObjects(limit: Int, completed: @escaping (Result<[Object], ErrorMessage>) -> Void) {
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
    
    //new methods to fetch
    func getObjectsAsync(limit: Int) async throws -> [Object] {
        let endpoint = "https://api.github.com/users/sallen0400/followers?per_page=\(limit)&page=1"
        guard let url = URL(string: endpoint) else {
            throw ErrorMessage.invalidData
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw ErrorMessage.invalidResponse
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode([Object].self, from: data)
            } catch {
                throw ErrorMessage.invalidData
            }
        }
        
    func getObjects2Async() async throws -> [Object2] {
        let endpoint = "https://api.letsbuildthatapp.com/appstore/social"
        guard let url = URL(string: endpoint) else {
            throw ErrorMessage.invalidData
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw ErrorMessage.invalidResponse
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode([Object2].self, from: data)
            } catch {
                throw ErrorMessage.invalidData
            }
        }
}
