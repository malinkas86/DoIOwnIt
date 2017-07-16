//
//  StringUtil.swift
//  DoIOwnIt
//
//  Created by Malinka S on 4/17/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class StringUtil: NSObject {
    
    static func formatReleaseDate(strValue: String, offsetBy: Int) -> String {
        if strValue.characters.count > offsetBy {
            let index = strValue.index(strValue.startIndex, offsetBy: offsetBy)
            return strValue.substring(to: index)
        }
        return "N/A"
        
    }
}
