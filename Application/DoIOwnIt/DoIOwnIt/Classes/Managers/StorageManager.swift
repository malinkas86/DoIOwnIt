//
//  StorageManager.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/7/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class StorageManager: NSObject {
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
    
    func saveMovieStoragePreferences(movieId : Int, title : String, posterPath : String, releasedDate : String,storageMethods : [StorageType : String], completionHandler : @escaping (_ response : Response<Any>) -> ()){
        var refactoredStorageMethods : [StorageType : StorageMethod] = [:]
        for (type, string) in storageMethods {
            refactoredStorageMethods[type] = StorageMethod(storageType: type, methods: string)
        }
        let operation = UserMovieRepositoryOperation(userMovieOperationType: .saveusermovie, userMovieRepository: userMovieRepository!, completionHandler: { response in
            
            switch response {
            case let .success(movie):
                completionHandler(Response.success(movie))
            case let .error(error):
                completionHandler(Response.error(error))
            }
        })
        operation.movieId = movieId
        operation.title = title
        operation.posterPath = posterPath
        operation.releasedDate = releasedDate
        operation.storageMethods = refactoredStorageMethods
        
        userMovieRepositoryQueue.addOperation(operation)
    }

}
