//
//  Bundle+Extension.swift
//  IOS Concurrency
//
//  Created by Eric on 19/11/2022.
//

import Foundation

// INFO: Use to fetch the data localy with users and posts.json in the preview content, not for the final purpose of the app.

extension Bundle {
    public func decode<T: Decodable>(_ type: T.Type,
                                     from file: String,
                                     dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                     keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy
        guard let decodedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        return decodedData
    }
}
