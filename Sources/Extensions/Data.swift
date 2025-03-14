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

}
