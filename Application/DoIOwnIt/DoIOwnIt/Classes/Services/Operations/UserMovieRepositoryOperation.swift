//
//  UserMovieRepositoryOperation.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/7/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class UserMovieRepositoryOperation: AsynchronousOperation {
    var userMovieOperationType : UserMovieOperationType
    var userMovieRepository : UserMovieRespositoryProtocol
    var completionHandler : (_ response : Response<Any>) -> ()
    
    var movieId : Int?
    var title : String?
    var posterPath : String?
    var releasedDate : String?
    var storageMethods : [StorageType : StorageMethod]?
    
    init(userMovieOperationType : UserMovieOperationType, userMovieRepository : UserMovieRespositoryProtocol, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        self.userMovieOperationType = userMovieOperationType
        self.userMovieRepository = userMovieRepository
        self.completionHandler = completionHandler
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        switch self.userMovieOperationType {
        case .saveusermovie:
            userMovieRepository.saveUserMovie(movieId: movieId!, title: title!, posterPath: posterPath!, releasedDate: releasedDate!, storageMethods: storageMethods!, completionHandler: { response in
                self.completionHandler(response)
                self.completeOperation()
            })
        default : break
        }
    }
}
