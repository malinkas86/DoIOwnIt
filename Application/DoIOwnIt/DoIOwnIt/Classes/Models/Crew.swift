//
//  Crew.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/25/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class Crew: NSObject {
    var id : Int?
    var department : String?
    var name : String?
    var job : String?
    
    init(withDictionary dictionary : [String : Any]){
        if let id = dictionary["id"] as? Int? {
            self.id = id
        }
        if let department = dictionary["department"] as? String? {
            self.department = department
        }else{
            self.department = ""
        }
        if let job = dictionary["job"] as? String? {
            self.job = job
        }else{
            self.job = ""
        }
        if let name = dictionary["name"] as? String? {
            self.name = name
        }else{
            self.name = ""
        }
        
        
    }
}
