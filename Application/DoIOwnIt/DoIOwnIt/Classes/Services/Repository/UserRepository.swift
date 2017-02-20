//
//  UserPersistence.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/20/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import Firebase

class UserRepository: UserRepositoryProtocol {
    
    var ref: FIRDatabaseReference!
    

    func checkUserAndSave(user : FIRUser, username : String, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        self.ref = FIRDatabase.database().reference()
        
        self.ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            var fullNameArr = user.displayName?.components(separatedBy: " ")
            
            let firstName = (fullNameArr?.count)! > 0 ? fullNameArr![0] : ""
            let lastName = (fullNameArr?.count)! > 1 ? fullNameArr![1] : ""
            // Check if user already exists
            guard !snapshot.exists() else {
                completionHandler(Response.success(user))
                return
            }
            
            self.saveUserInfo(user : user, username : username, firstName: firstName, lastName: lastName, completionHandler: completionHandler)
        })
    }
    
    
    func saveUserInfo(user : FIRUser, username : String, firstName : String, lastName : String, completionHandler : @escaping (_ response : Response<Any>) -> ()) {
        
        self.ref = FIRDatabase.database().reference()
        
        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
        changeRequest?.displayName = "\(firstName) \(lastName)"
        changeRequest?.commitChanges(){ (error) in
            
            if let error = error {
                completionHandler(Response.error(error.localizedDescription))
                return
            }
            
            self.ref.child("users").child((user.uid)).setValue(User(username: username, firstName: firstName, lastName: lastName).toDictionary())
            completionHandler(Response.success(user))
        }
    }
    
    
    func signInUser(withEmail email : String, password : String, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user,error) in
            guard let user = user, error == nil else {
                print(error!.localizedDescription)
                completionHandler(Response.error((error?.localizedDescription)! ))
                return
            }
            
            completionHandler(Response.success(user))
        })
    }
    
    func signInUser(withCredential credential : FIRAuthCredential, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            
            guard let user = user, error == nil else {
                print(error!.localizedDescription)
                completionHandler(Response.error((error?.localizedDescription)!))
                return
            }
            
            self.checkUserAndSave(user : user, username : user.email!, completionHandler : completionHandler)
            
            
        }
    }
}
