//
//  String.swift
//  docmgr
//
//  Created by Sudovsky on 26.10.2019.
//  Copyright © 2019 Max Sudovsky. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    
    func readJson<T>(as asType: T.Type = [String: Any].self as! T.Type, completion: (T?, String?) -> Void = { _,_ in }) {
        
        guard let resource = self.data(using: .utf8) else {
            completion(nil, "Invalid string")
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: resource, options: [.allowFragments, .fragmentsAllowed]) as? T {
                completion(json, nil)
            } else {
                completion(nil, "Couldn't recognize JSON")
            }
        } catch {
            completion(nil, error.localizedDescription)
        }
        
    }

    func readJson<T>(as asType: T.Type = [String: Any].self as! T.Type) throws -> T {
        
        guard let resource = self.data(using: .utf8) else {
            throw NSError(domain: NSOSStatusErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid string"])
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: resource, options: [.allowFragments, .fragmentsAllowed]) as? T {
                return json
            } else {
                throw NSError(domain: NSOSStatusErrorDomain, code: 1, userInfo: [NSLocalizedDescriptionKey: "Couldn't recognize JSON"])
            }
        } catch {
            throw error
        }
        
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    func getSize(font: UIFont?) -> CGSize {
        
        let attributes = font != nil ? [NSAttributedString.Key.font: font!] : [:]
        return self.size(withAttributes: attributes)
        
    }
     
    var color: UIColor {
        
        var hexInt: UInt64 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: self.uppercased())
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt64(&hexInt)
        
        // Convert hex string to an integer
        //let hexint = Int(self.intFromHexString())
        let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexInt & 0xff) >> 0) / 255.0
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return color
        
    }
    
    func imageFromBase64() -> UIImage? {
        
        if let imageData = Data(base64Encoded: self, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
            
            return UIImage(data: imageData as Data) ?? UIImage()
            
        } else {
            return nil
        }
        
    }
    
    func date(format: String = "yyyy-MM-dd'T'HH:mm:ss") -> Date? {
        
        var cdate = self
        
        if cdate.isEmpty {
            cdate = "0001-01-01'T'00:00:00"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
        
    }

    func imageFromURL() -> UIImage? {
        
        do {
            let url = URL(string: self)
            let data = try Data(contentsOf: url!)
            
            if let image = UIImage(data: data) {
                return image
            }
        } catch { print("error") }
        return nil
        
    }
    
    func checkMail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)

    }
    
    var isAlphanumeric: Bool {
        return range(of: "[^a-zA-Z0-9_]", options: .regularExpression) == nil
    }

    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
//    ^     #Match the beginning of the string
//    [6-9] #Match a 6, 7, 8 or 9
//    \\d   #Match a digit (0-9 and anything else that is a "digit" in the regex engine)
//    {9}   #Repeat the previous "\d" 9 times (9 digits)
//    $     #Match the end of the string
    var isValidContact: Bool {
        let phoneNumberRegex = "^[7-8]\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
    
    func digits() -> String {
        return filter("0123456789.".contains)
    }
    
    func normalizedPhoneNumber() -> String? {
        var newStr = self.digits()
        if newStr.isEmpty {
            return nil
        }
        
        if newStr[0] == "9", newStr.count == 10 {
            newStr = "7" + newStr
        } else if newStr[0] == "8", let index = newStr.firstIndex(of: "8") {
            newStr.replaceSubrange(index...index, with: ["7"])
        }
        
        if newStr.isValidContact {
            return newStr
        } else {
            return nil
        }
    }

    func stringByReplacingFirstOccurrenceOfString(target: String, withString replaceString: String) -> String
    {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
    
}

