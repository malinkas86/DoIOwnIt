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
    var searchMovies: [Movie] = []
    
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
    
    func getUserMovies(byQuery query: String, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        
        userMovieManager.getUserMovies(byQuery: query, completionHandler: { response in
            switch response {
            case let .success(movies as [Movie]):
                self.searchMovies = movies
                log.info("movie count\(self.searchMovies.count)")
                analyticsManager.logEvent("search_user_movie", parameters: ["status": "success",
                                                                "query": query,
                                                                "result_count": self.searchMovies.count])
                completionHandler(Response.success(true))
            case .error(_) :
                analyticsManager.logEvent("search_user_movie", parameters: ["status": "failure",
                                                                     "query": query])
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
                analyticsManager.logEvent("remove_movie", parameters: ["status": "success",
                                                                "movie_id": movieId])
                completionHandler(Response.success(true))
            case .error(_) :
                analyticsManager.logEvent("remove_movie", parameters: ["status": "failure",
                                                                "movie_id": movieId])

                completionHandler(Response.error("Error occurred while retreiving data"))
            
            }
            
        })
    }
}
