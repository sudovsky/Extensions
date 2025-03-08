//
//  JSONExt.swift
//  Extensions
//
//  Created by Max Sudovsky on 09.03.2025.
//

import Foundation

func load<T: Decodable>(_ data: Data, dataFromBase64String: Bool = false) -> T? {
    
    @Sendable func customDataDecoder(decoder: Decoder) throws -> Data {
        let container = try decoder.singleValueContainer()
        let str = try container.decode(String.self)
        
        guard let imageData = Data(base64Encoded: str, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) else {
            
            throw NSError()
            
        }
        
        return imageData
    }

    do {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        if dataFromBase64String {
            decoder.dataDecodingStrategy = .custom(customDataDecoder)
        }
        return try decoder.decode(T.self, from: data)
    } catch {
        print(error.localizedDescription)
        return nil
    }
    
}

extension Encodable {
    
    func toJSON() throws -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        encoder.dataEncodingStrategy = .base64
        encoder.outputFormatting = .prettyPrinted
        return try String(data: encoder.encode(self), encoding: .utf8)
    }
    
    func save(_ file: URL) throws {
        if let text = try toJSON() {
            if FileManager.default.fileExists(atPath: file.path) {
                try FileManager.default.removeItem(at: file)
            }
            
            FileManager.default.createFile(atPath: file.path, contents: text.data(using: .utf8))
        }
    }
    
}
