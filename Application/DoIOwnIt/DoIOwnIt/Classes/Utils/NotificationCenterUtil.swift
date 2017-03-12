//
//  NotificationCenterUtil.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/11/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class NotificationCenterUtil: NSObject {

    static func postNotification(name : String, value : [String : Any]){
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue: name),
                object: nil,
                userInfo: value)
    }
    
//    static func addObserver(name : String, completion : (Notification)-> ()){
//        
//    }
}
