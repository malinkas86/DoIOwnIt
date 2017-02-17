//
//  UserPersistenceOperation.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/16/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

import Firebase

enum UserOperationType {
    case saveuser, checkandsaveuser
}

class UserPersistenceOperation: AsynchronousOperation {
    
    var ref: FIRDatabaseReference!
    var userOperationType : UserOperationType
    var completionHandler : (_ response : Response<Any>) -> ()
    var user : FIRUser!
    var username : String!
    var firstName : String!
    var lastName : String!
    
    init(userOperationType : UserOperationType, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        self.userOperationType = userOperationType
        self.ref = FIRDatabase.database().reference()
        self.completionHandler = completionHandler
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        switch self.userOperationType {
        case .saveuser:
            saveUserInfo()
        case .checkandsaveuser:
            checkUserAndSave()
            
        }
    }
    
    func checkUserAndSave(){
        self.ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            var fullNameArr = self.user.displayName?.components(separatedBy: " ")
            
            self.firstName = (fullNameArr?.count)! > 0 ? fullNameArr![0] : ""
            self.lastName = (fullNameArr?.count)! > 1 ? fullNameArr![1] : ""
            // Check if user already exists
            guard !snapshot.exists() else {
                self.completionHandler(Response.success(self.user))
                self.completeOperation()
                return
            }
            
            self.saveUserInfo()
        })
    }
    
    
    func saveUserInfo() {
        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
        changeRequest?.displayName = "\(firstName) \(lastName)"
        changeRequest?.commitChanges(){ (error) in
            
            if let error = error {
                self.completionHandler(Response.error(error.localizedDescription ))
                return
            }
            
            self.ref.child("users").child((self.user?.uid)!).setValue(User(username: self.username!, firstName: self.firstName!, lastName: self.lastName!).toDictionary())
            self.completionHandler(Response.success(self.user))
            self.completeOperation()
        }
    }
}
