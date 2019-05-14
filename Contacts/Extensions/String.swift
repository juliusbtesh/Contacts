//
//  String.swift
//  Contacts
//
//  Created by Julius Btesh on 5/13/19.
//  Copyright © 2019 Julius Btesh. All rights reserved.
//

import Foundation

extension String {
    func date(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: self)
        return date
    }
    
    // Just using this for specific case of xxx-xxx-xxxx
    func formattedPhoneNumber() -> String? {
        let numbers = self.split(separator: "-")
        if numbers.count == 3 {
            return "(\(numbers[0])) \(numbers[1])-\(numbers[2])"
        }
        return self
    }
}
