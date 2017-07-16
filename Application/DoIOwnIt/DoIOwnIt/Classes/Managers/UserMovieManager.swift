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
    
    var userMovieRepository: UserMovieRespositoryProtocol?
    
    init(userMovieRepository: UserMovieRespositoryProtocol){
        self.userMovieRepository = userMovieRepository
    }
    
    func getUserMovies(completionHandler: @escaping (Response<Any>) -> ()){
        
        if let userMovieRepository = self.userMovieRepository {
            let operation = UserMovieRepositoryOperation(userMovieOperationType: .getusermovie, userMovieRepository: userMovieRepository,
                completionHandler: { response in
                
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
    
    func getUserMovies(byQuery query: String, completionHandler: @escaping (Response<Any>) -> ()){
        
        if let userMovieRepository = self.userMovieRepository {
            let operation = UserMovieRepositoryOperation(userMovieOperationType: .searchUserMovies, userMovieRepository: userMovieRepository, completionHandler: { response in
                switch response {
                case let .success(movies as [Movie]) :
                    completionHandler(Response.success(movies))
                case let .error(error) :
                    completionHandler(Response.error(error))
                default : break
                    
                }
            })
            operation.searchQuery = query
            userMovieRepositoryQueue.addOperation(operation)
        }

    }
    
    func getUserMovieById(movieId : Int, completionHandler : @escaping (Response<Any>) -> ()){
        
        if let userMovieRepository = self.userMovieRepository {
            let operation = UserMovieRepositoryOperation(userMovieOperationType: .getusermoviebyid, userMovieRepository: userMovieRepository, completionHandler: { response in
                switch response {
                case let .success(movie as Movie) :
                    completionHandler(Response.success(movie))
                case let .error(error) :
                    completionHandler(Response.error(error))
                default : break
                    
                }
            })
            operation.movieId = movieId
            userMovieRepositoryQueue.addOperation(operation)
        }
    
    }
    
    func removeUserMovie(movieId : Int, completionHandler : @escaping (Response<Any>) -> ()){
        if let userMovieRepository = self.userMovieRepository {
            let operation = UserMovieRepositoryOperation(userMovieOperationType: .removeusermovie, userMovieRepository: userMovieRepository, completionHandler: { response in
                switch response {
                case .success(_) :
                    completionHandler(Response.success(true))
                case let .error(error) :
                    completionHandler(Response.error(error))
                    
                }
            })
            operation.movieId = movieId
            userMovieRepositoryQueue.addOperation(operation)
        }
        
    }

}
