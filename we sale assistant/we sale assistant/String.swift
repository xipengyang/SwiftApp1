import Foundation

public extension String {
    
    /**
    String length
    */
    var length: Int { return countElements(self) }
    
    /**
    self.capitalizedString shorthand
    */
    var capitalized: String { return capitalizedString }
    
    /**
    Returns the substring in the given range
    
    :param: range
    :returns: Substring in range
    */
    subscript (range: Range<Int>) -> String? {
        if range.startIndex < 0 || range.endIndex > self.length {
            return nil
        }
        
        let range = Range(start: advance(startIndex, range.startIndex), end: advance(startIndex, range.endIndex))
        
        return self[range]
    }
    
    
    
    
    /**
    Returns an array of strings, each of which is a substring of self formed by splitting it on separator.
    
    :param: separator Character used to split the string
    :returns: Array of substrings
    */
    func explode (separator: Character) -> [String] {
        return split(self, { (element: Character) -> Bool in
            return element == separator
        })
    }
    
    
    /**
    Inserts a substring at the given index in self.
    
    :param: index Where the new string is inserted
    :param: string String to insert
    :returns: String formed from self inserting string at index
    */
    func insert (var index: Int, _ string: String) -> String {
        //  Edge cases, prepend and append
        if index > length {
            return self + string
        } else if index < 0 {
            return string + self
        }
        
        return self[0..<index]! + string + self[index..<length]!
    }
    
    /**
    Strips whitespaces from the beginning of self.
    
    :returns: Stripped string
    */
    func ltrimmed () -> String {
        return ltrimmed(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    /**
    Strips the specified characters from the beginning of self.
    
    :returns: Stripped string
    */
    func ltrimmed (set: NSCharacterSet) -> String {
        if let range = rangeOfCharacterFromSet(set.invertedSet) {
            return self[range.startIndex..<endIndex]
        }
        
        return ""
    }
    
    /**
    Strips whitespaces from the end of self.
    
    :returns: Stripped string
    */
    func rtrimmed () -> String {
        return rtrimmed(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    /**
    Strips the specified characters from the end of self.
    
    :returns: Stripped string
    */
    func rtrimmed (set: NSCharacterSet) -> String {
        if let range = rangeOfCharacterFromSet(set.invertedSet, options: NSStringCompareOptions.BackwardsSearch) {
            return self[startIndex..<range.endIndex]
        }
        
        return ""
    }
    
    /**
    Strips whitespaces from both the beginning and the end of self.
    
    :returns: Stripped string
    */
    func trimmed () -> String {
        return ltrimmed().rtrimmed()
    }
    
    
    func toDouble() -> Double? {
        
        enum F {
            static let formatter = NSNumberFormatter()
        }
        if let number = F.formatter.numberFromString(self) {
            return number.doubleValue
        }
        
        return nil
    }
    
    /**
    Parses a string containing a float numerical value into an optional float if the string is a well formed number.
    
    :returns: A float parsed from the string or nil if it cannot be parsed.
    */
    func toFloat() -> Float? {
        if let val = self.toDouble() {
            return Float(val)
        }
        
        return nil
    }
    
    /**
    Parses a string containing a non-negative integer value into an optional UInt if the string is a well formed number.
    
    :returns: A UInt parsed from the string or nil if it cannot be parsed.
    */
    func toUInt() -> UInt? {
        if let val = self.trimmed().toInt() {
            if val < 0 {
                return nil
            }
            return UInt(val)
        }
        
        return nil
    }
    
    
    /**
    Parses a string containing a boolean value (true or false) into an optional Bool if the string is a well formed.
    
    :returns: A Bool parsed from the string or nil if it cannot be parsed as a boolean.
    */
    func toBool() -> Bool? {
        let text = self.trimmed().lowercaseString
        if text == "true" || text == "false" || text == "yes" || text == "no" {
            return (text as NSString).boolValue
        }
        
        return nil
    }
    
    /**
    Parses a string containing a date into an optional NSDate if the string is a well formed.
    The default format is yyyy-MM-dd, but can be overriden.
    
    :returns: A NSDate parsed from the string or nil if it cannot be parsed as a date.
    */
    func toDate(format : String? = "yyyy-MM-dd") -> NSDate? {
        let text = self.trimmed().lowercaseString
        var dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        if let fmt = format {
            dateFmt.dateFormat = fmt
        }
        return dateFmt.dateFromString(text)
    }
    
    /**
    Parses a string containing a date and time into an optional NSDate if the string is a well formed.
    The default format is yyyy-MM-dd hh-mm-ss, but can be overriden.
    
    :returns: A NSDate parsed from the string or nil if it cannot be parsed as a date.
    */
    func toDateTime(format : String? = "yyyy-MM-dd hh-mm-ss") -> NSDate? {
        return toDate(format: format)
    }
    
}

