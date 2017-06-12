//
//  UserMovieLibraryViewModel.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/9/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class UserMovieLibraryViewModel: NSObject {
    
    let userMovieManager = UserMovieManager(userMovieRepository: UserMovieRepository())
    
    func getUserMovies(completionHandler : @escaping (_ response : Response<Any>) -> ()){
        
        userMovieManager.getUserMovies(completionHandler: { response in
            switch response {
            case let .success(movies as [Movie]):
                userMovies = movies
                log.info("movie count\(userMovies.count)")
                completionHandler(Response.success(true))
            case .error(_) :
                completionHandler(Response.error("Error occurred while retreiving data"))
            default :
                break
            }
            
        })
    }
    
    func removeMovie(movieId : Int, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        
        userMovieManager.removeUserMovie(movieId: movieId, completionHandler: { response in
            switch response {
            case .success(_):
                completionHandler(Response.success(true))
            case .error(_) :
                completionHandler(Response.error("Error occurred while retreiving data"))
            
            }
            
        })
    }
}
