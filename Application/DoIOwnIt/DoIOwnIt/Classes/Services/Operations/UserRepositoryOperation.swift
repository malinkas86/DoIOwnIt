//
//  UserPersistenceOperation.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/16/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

import Firebase



class UserRepositoryOperation: AsynchronousOperation {
    
    var userOperationType : UserOperationType
    var userRepository : UserRepositoryProtocol
    var completionHandler : (_ response : Response<Any>) -> ()
    var user : FIRUser?
    var email : String?
    var credential : FIRAuthCredential?
    var password : String?
    var username : String?
    var firstName : String?
    var lastName : String?
    
    init(userOperationType : UserOperationType, userRepository : UserRepositoryProtocol, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        self.userOperationType = userOperationType
        self.userRepository = userRepository
        self.completionHandler = completionHandler
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        switch self.userOperationType {
        case .saveuser:
            userRepository.saveUserInfo(user : user!, username : (user?.email!)!, firstName : firstName!, lastName : lastName!, completionHandler : { response in
                self.completionHandler(response)
                self.completeOperation()
            })
        case .checkandsaveuser:
            userRepository.checkUserAndSave(user : user!, username : (user?.email!)!, completionHandler : { response in
                self.completionHandler(response)
                self.completeOperation()
            })
        case .signinwithemail :
            userRepository.signInUser(withEmail : email!, password : password!, completionHandler : { response in
                self.completionHandler(response)
                self.completeOperation()
            })
        case .signinwithcredentials :
            userRepository.signInUser(withCredential : credential! , completionHandler : { response in
                self.completionHandler(response)
                self.completeOperation()
            })
            
        }
    }
    
    
}
