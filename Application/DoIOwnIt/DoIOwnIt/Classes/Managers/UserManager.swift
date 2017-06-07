//
//  UserManager.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/20/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import Firebase

class UserManager: UserManagerProtocol {
    lazy var userRepositoryQueue : OperationQueue = {
        var queue = OperationQueue()
        queue.name = "userRepositoryQueue"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
    var userRepository : UserRepositoryProtocol?
    
    init(userRepository : UserRepositoryProtocol){
        self.userRepository = userRepository
    }
    
    func signInUser(withEmail email : String, password : String, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        
        let operation = UserRepositoryOperation(userOperationType: .signinwithemail, userRepository: userRepository!, completionHandler: { response in
            switch response {
            case let .success(user) :
                completionHandler(Response.success(user))
            case let .error(error) :
                completionHandler(Response.error(error))
            }
            
        })
        operation.email = email
        operation.password = password
        userRepositoryQueue.addOperation(operation)
        
    }
    
    func signInUser(withCredential credential : AuthCredential, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        let operation = UserRepositoryOperation(userOperationType: .signinwithcredentials, userRepository: userRepository!, completionHandler: { response in
            switch response {
            case let .success(user) :
                completionHandler(Response.success(user))
            case let .error(error) :
                completionHandler(Response.error(error))
            }
            
        })
        operation.credential = credential
        userRepositoryQueue.addOperation(operation)
    }
}
