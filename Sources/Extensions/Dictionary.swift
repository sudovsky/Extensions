//
//  Dictionary.swift
//  Extensions
//
//  Created by Sudovsky on 15.05.2020.
//

import UIKit

public extension Dictionary where Key: ExpressibleByStringLiteral {
    
    var string: String? {
        do {
            let stringResult = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            if let res = String(data: stringResult, encoding: .utf8) {
                return res
            }
        } catch {
            return nil
        }
        
        return nil
    }
    
}

