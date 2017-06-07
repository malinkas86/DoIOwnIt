//
//  UserManagerProtocol.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/20/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import Firebase

protocol UserManagerProtocol {
    func signInUser(withEmail email : String, password : String, completionHandler : @escaping (_ response : Response<Any>) -> ())
    func signInUser(withCredential credential : AuthCredential, completionHandler : @escaping (_ response : Response<Any>) -> ())
    
}
