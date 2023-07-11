//
//  StringExtension.swift
//  wisnet
//
//  Created by Tan Vo on 12/10/2022.
//

import Foundation

public extension String {
    var isBlank: Bool {
        return trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
    }
    
    var isValidEmailAddress: Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
        } catch {
            returnValue = false
        }
        
        return  returnValue
    }
    
    var phoneFormat: String {
        if self.count >= 7 {
            var str = self
            str.insert(" ", at: str.index(str.startIndex, offsetBy: 3))
            str.insert(" ", at: str.index(str.startIndex, offsetBy: 7))
            return str
        } else {
            return self
        }
    }
    
    var isValidPhone: Bool {
        if self.hasSpecialCharacters(){
            return false
        }
        
        guard self.count == 10 || self.count == 9 else {
            return false
        }
        
        let charcterSet = NSCharacterSet(charactersIn: "0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
    
    func isValidPassword(minimumCount: Int) -> Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).count >= minimumCount
    }
    
    func hasSpecialCharacters() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }

        } catch {
            debugPrint(error.localizedDescription)
            return false
        }

        return false
    }
    
    func duplicateWhiteSpace(_ spacing: Int) -> String{
        var str = ""
        for _ in 0...(spacing) {
            str += " "
        }
        return str
    }
}
