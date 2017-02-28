//
//  Cast.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/25/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class Cast: NSObject {
    var id : Int?
    var order : Int?
    var character : String?
    var name : String?
    
    init(withDictionary dictionary : [String : Any]){
        if let id = dictionary["id"] as? Int? {
            self.id = id
        }
        if let order = dictionary["order"] as? Int? {
            self.order = order
        }else{
            self.order = 0
        }
        if let charachter = dictionary["character"] as? String? {
            self.character = charachter
        }else{
            self.character = ""
        }
        if let name = dictionary["name"] as? String? {
            self.name = name
        }else{
            self.name = ""
        }
        
        
    }

}
