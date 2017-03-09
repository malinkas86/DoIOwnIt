//
//  StorageMethod.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/28/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

struct StorageMethod {
    var storageType : StorageType?
    var methods : String?
    
    
    func toDictionary() -> [String : Any]{
        return [(storageType?.rawValue)! : methods!]
    }
}
