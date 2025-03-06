//
//  Data.swift
//  Extensions
//
//  Created by Max Sudovsky on 06.03.2025.
//

import Foundation

extension Data {
    
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

}
