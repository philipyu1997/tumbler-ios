//
//  K.swift
//  Tumbler
//
//  Created by Philip Yu on 5/11/20.
//  Copyright © 2020 Philip Yu. All rights reserved.
//

import UIKit

struct Constants {
    
    static let avatarURL = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!
    
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
    
    static func circularImageView(image: UIImageView) {
        
        image.layer.cornerRadius = (image.frame.size.width) / 2
        image.clipsToBounds = true
        
    }
    
}
