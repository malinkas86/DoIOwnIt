//
//  User.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/16/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class User: NSObject {
    var username : String?
    var firstName : String?
    var lastName : String?
    
    override init() {
        
    }
    
    init(username : String, firstName : String, lastName : String) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func toDictionary() -> [String : String] {
        let dictionary : [String : String] = ["username" : self.username ?? "" , "firstName" : self.firstName ?? "", "lastName" : self.lastName!]
        return dictionary
    }
    
}
