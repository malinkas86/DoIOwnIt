//
//  UserPersistenceProtocol.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/20/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import Foundation
import Firebase

enum UserOperationType {
    case saveuser, checkandsaveuser, signinwithemail, signinwithcredentials
}

protocol UserRepositoryProtocol {
    func checkUserAndSave(user : FIRUser, username : String, completionHandler : @escaping (_ response : Response<Any>) -> ())
    func saveUserInfo(user : FIRUser, username : String, firstName : String, lastName : String, completionHandler : @escaping (_ response : Response<Any>) -> ())
    func signInUser(withEmail email : String, password : String, completionHandler : @escaping (_ response : Response<Any>) -> ())
    func signInUser(withCredential credential : FIRAuthCredential, completionHandler : @escaping (_ response : Response<Any>) -> ())
}
