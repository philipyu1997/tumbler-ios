//
//  K.swift
//  Tumbler
//
//  Created by Philip Yu on 5/11/20.
//  Copyright © 2020 Philip Yu. All rights reserved.
//

import UIKit

struct Constant {
    
    // MARK: - Properties
    static let avatarURL = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!
    static let apiKey = fetchFromPlist(forResource: "ApiKeys", forKey: "API_KEY")
    
    // MARK: - Functions
    
    static func fetchFromPlist(forResource resource: String, forKey key: String) -> String? {
        
        let filePath = Bundle.main.path(forResource: resource, ofType: "plist")
        let plist = NSDictionary(contentsOfFile: filePath!)
        let value = plist?.object(forKey: key) as? String
        
        return value
        
    }
    
    static func convertDateFormatter(date: String) -> String {
        
        let dateString = date.replacingOccurrences(of: " GMT", with: "")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        guard let date = dateFormatter.date(from: dateString) else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "MMM dd, yyyy, h:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
        
    }
    
}

extension UIImageView {
    
    func makeCircular() {
        
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        
    }
    
}
