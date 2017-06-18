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
            case let .success(user as User):
                Analytics.setUserID(user.uid)
                Analytics.setUserProperty(user.uid, forName: "userId")
                Analytics.logEvent("login", parameters: ["status": "success",
                                                         "username": email])
                completionHandler(Response.success(user))
            case let .error(error) :
                Analytics.logEvent("login", parameters: ["status": "failure",
                                                         "username": email])
                completionHandler(Response.error(error))
            default:
                Analytics.logEvent("login", parameters: ["status": "failure",
                                                         "username": email])
            }
        })
    }
    
    func signInUser(withCredential credential : AuthCredential, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        userManager.signInUser(withCredential: credential, completionHandler: {response in
            switch response {
            case let .success(user as User):
                Analytics.setUserID(user.uid)
                Analytics.setUserProperty(user.uid, forName: "userId")
                Analytics.logEvent("login", parameters: ["status": "success",
                                                         "username": user.uid])
                completionHandler(Response.success(user))
            case let .error(error) :
                completionHandler(Response.error(error))
            default:
                Analytics.logEvent("login", parameters: ["status": "failure"])
            }
        })
    }
}
