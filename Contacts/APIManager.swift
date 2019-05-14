//
//  APIManager.swift
//  Contacts
//
//  Created by Julius Btesh on 5/13/19.
//  Copyright © 2019 Julius Btesh. All rights reserved.
//

import Foundation

class APIManger {
    
    static let shared = APIManger()
    
    private var searchTask: URLSessionDataTask?

    private init(){}
    
    func fetchContacts(_ completion: @escaping (NSArray?) -> Void) {
//        if let cachedVersion = CacheManager.shared.objectForKey(key: String(objectId) as NSString) {
//            completion(cachedVersion)
//            return
//        }
        let urlString = Constants.Paths.ContactsURL
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Getting response for POST Method
        DispatchQueue.main.async {
            if self.searchTask?.state == URLSessionTask.State.running {
                self.searchTask?.cancel()
            }
            
            self.searchTask = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    return // check for fundamental networking error
                }
                
                DispatchQueue.main.async {
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? NSArray
                        
                        guard let contacts = jsonResponse else {
                            completion(nil)
                            return
                        }
                        
//                        CacheManager.shared.setObjectForKey(object: objectInformation, key: id.stringValue as NSString)
                        
                        completion(contacts)
                    } catch _ {
                        print ("OOps not good JSON formatted response")
                    }
                }
            }
            self.searchTask?.resume()
        }
    }
}
