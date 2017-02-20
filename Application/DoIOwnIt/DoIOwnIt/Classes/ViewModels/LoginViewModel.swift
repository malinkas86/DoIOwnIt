//
//  LoginViewModel.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/16/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import Firebase

class LoginViewModel: NSObject {

    
    let userManager = UserManager(userRepository: UserRepository())
    
    func signInUser(withEmail email : String, password : String, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        userManager.signInUser(withEmail: email, password: password, completionHandler: { response in
            switch response {
            case let .success(user):
                completionHandler(Response.success(user))
            case let .error(error) :
                completionHandler(Response.error(error))
            }
        })
    }
    
    func signInUser(withCredential credential : FIRAuthCredential, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        userManager.signInUser(withCredential: credential, completionHandler: {response in
            switch response {
            case let .success(user):
                completionHandler(Response.success(user))
            case let .error(error) :
                completionHandler(Response.error(error))
            }
        })
    }
}
