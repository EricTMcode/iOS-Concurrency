//
//  APIService.swift
//  IOS Concurrency
//
//  Created by Eric on 19/11/2022.
//

import Foundation

struct APIService {
    
    let urlString: String
    
    func getJSON<T: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                                completion: @escaping (Result<T, APIError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalideURL))
            return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponseStatus))
                return }
            
            guard error == nil else {
                completion(.failure(.dataTaskError))
                return }
            
            guard let data = data else {
                completion(.failure(.corruptData))
                return }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        .resume()
    }
    
}

enum APIError: Error {
    case invalideURL
    case invalidResponseStatus
    case dataTaskError
    case corruptData
    case decodingError
}
