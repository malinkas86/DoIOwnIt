//
//  UserMovieManager.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/9/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class UserMovieManager: UserMovieManagerProtocol {
    lazy var userMovieRepositoryQueue : OperationQueue = {
        var queue = OperationQueue()
        queue.name = "userMovieRepositoryQueue"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
    
    var userMovieRepository : UserMovieRespositoryProtocol?
    
    init(userMovieRepository : UserMovieRespositoryProtocol){
        self.userMovieRepository = userMovieRepository
    }
    
    func getUserMovies(completionHandler : @escaping (Response<Any>) -> ()){
        let operation = UserMovieRepositoryOperation(userMovieOperationType: .getusermovie, userMovieRepository: self.userMovieRepository!, completionHandler: { response in
            switch response {
            case let .success(movies as [Movie]) :
                completionHandler(Response.success(movies))
            case let .error(error) :
                completionHandler(Response.error(error))
            default : break
                
            }
        })
        userMovieRepositoryQueue.addOperation(operation)
    }

}
