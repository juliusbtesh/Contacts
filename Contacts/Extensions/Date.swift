//
//  Date.swift
//  Contacts
//
//  Created by Julius Btesh on 5/13/19.
//  Copyright © 2019 Julius Btesh. All rights reserved.
//

import Foundation

extension Date {
    func asBirthday() -> String? {
        return DateFormatter.localizedString(from: self, dateStyle: .long, timeStyle: .none)
    }
}
