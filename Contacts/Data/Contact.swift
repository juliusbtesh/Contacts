//
//  Contact.swift
//  Contacts
//
//  Created by Julius Btesh on 5/13/19.
//  Copyright © 2019 Julius Btesh. All rights reserved.
//

import Foundation

class Contact {
    public var id: String?
    public var name: String?
    public var phone: NSDictionary?
    public var address: NSDictionary?
    public var birthdate: String?
    public var companyName: String?
    public var emailAddress: String?
    public var isFavorite: Bool?
    public var smallImageURL: String?
    public var largeImageURL: String?
    
    init(contactInformation: NSDictionary) {
        id = contactInformation[Constants.Contact.ID] as? String
        name = contactInformation[Constants.Contact.Name] as? String
        phone = contactInformation[Constants.Contact.Phone] as? NSDictionary
        address = contactInformation[Constants.Contact.Address] as? NSDictionary
        birthdate = contactInformation[Constants.Contact.Birthdate] as? String
        companyName = contactInformation[Constants.Contact.CompanyName] as? String
        emailAddress = contactInformation[Constants.Contact.EmailAddress] as? String
        isFavorite = contactInformation[Constants.Contact.IsFavorite] as? Bool
        smallImageURL = contactInformation[Constants.Contact.SmallImageURL] as? String
        largeImageURL = contactInformation[Constants.Contact.LargeImageURL] as? String
    }
    
    func fullAddress() -> String? {
        return "\(self.address?.object(forKey: Constants.Contact.AddressInfo.Street) ?? "")\n\(self.address?.object(forKey: Constants.Contact.AddressInfo.City) ?? ""), \(self.address?.object(forKey: Constants.Contact.AddressInfo.State) ?? "") \(self.address?.object(forKey: Constants.Contact.AddressInfo.ZipCode) ?? ""), \(self.address?.object(forKey: Constants.Contact.AddressInfo.Country) ?? "")"
    }
}
