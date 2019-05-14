//
//  Constants.swift
//  Contacts
//
//  Created by Julius Btesh on 5/13/19.
//  Copyright © 2019 Julius Btesh. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let userAddFavorite = Notification.Name("userAddedFavorite")
    static let userRemovedFavorite = Notification.Name("userRemovedFavorite")
}

struct Constants {
    struct Paths {
        static let ContactsURL = "https://s3.amazonaws.com/technical-challenge/v3/contacts.json"
    }
    
    struct Images {
        static let DefaultUserImageSmall = "user_icon_small"
        static let DefaultUserImageLarge = "user_icon_large"
        
        static let FavoriteTrue = "favorite_true"
        static let FavoriteFalse = "favorite_false"
    }
    
    struct Sizes {
        static let ContactCellHeight = 90
        static let DetailHeaderHeight = 240
        static let DetailCellHeight = 100
    }
    
    struct Contact {
        static let ID = "id"
        static let Name = "name"
        static let Phone = "phone"
        static let Address = "address"
        static let Birthdate = "birthdate"
        static let CompanyName = "companyName"
        static let EmailAddress = "emailAddress"
        static let IsFavorite = "isFavorite"
        static let SmallImageURL = "smallImageURL"
        static let LargeImageURL = "largeImageURL"
        
        struct PhoneInfo {
            static let Home = "home"
            static let Mobile = "Mobile"
            static let Work = "Work"
        }
        
        struct AddressInfo {
            static let City = "city"
            static let Country = "country"
            static let State = "state"
            static let Street = "street"
            static let ZipCode = "zipCode"
        }
    }
}
