//
//  Data.swift
//  Extensions
//
//  Created by Max Sudovsky on 06.03.2025.
//

import Foundation

public extension Data {
    
    func readJson<T>(as asType: T.Type = [String: Any].self as! T.Type, completion: (T?, String?) -> Void = { _,_ in }) {
        
        do {
            if let json = try JSONSerialization.jsonObject(with: self, options: [.allowFragments, .fragmentsAllowed]) as? T {
                completion(json, nil)
            } else {
                completion(nil, "Couldn't recognize JSON")
            }
        } catch {
            completion(nil, error.localizedDescription)
        }
        
    }

    func readJson<T>(as asType: T.Type = [String: Any].self as! T.Type) throws -> T {
        
        do {
            if let json = try JSONSerialization.jsonObject(with: self, options: [.allowFragments, .fragmentsAllowed]) as? T {
                return json
            } else {
                throw NSError(domain: NSOSStatusErrorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey: "Couldn't recognize JSON"])
            }
        } catch {
            throw error
        }
        
    }

    func saveDataFile(withName name: String) throws {
        let tempDirectoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let tempDirectoryURL = tempDirectoryURLs.first!
        let fileURL = tempDirectoryURL.appendingPathComponent(name)
        try self.write(to: fileURL)
    }
    
    static func loadDataFile(withName name: String) throws -> Data {
        let tempDirectoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let tempDirectoryURL = tempDirectoryURLs.first!
        let fileURL = tempDirectoryURL.appendingPathComponent(name)
        return try Data(contentsOf: fileURL)
    }
    
    static func removeDataFile(withName name: String) throws {
        let tempDirectoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let tempDirectoryURL = tempDirectoryURLs.first!
        let fileURL = tempDirectoryURL.appendingPathComponent(name)
        try FileManager.default.removeItem(at: fileURL)
    }

}
