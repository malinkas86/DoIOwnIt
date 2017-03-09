//
//  UserMovieLibraryViewModel.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/9/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class UserMovieLibraryViewModel: NSObject {
    var movies : [Movie] = []
    let userMovieManager = UserMovieManager(userMovieRepository: UserMovieRepository())
    
    func getUserMovies(completionHandler : @escaping (_ response : Response<Any>) -> ()){
        
        userMovieManager.getUserMovies(completionHandler: { response in
            switch response {
            case let .success(movies as [Movie]):
                self.movies = movies
                log.info("movie count\(self.movies.count)")
                completionHandler(Response.success(true))
            case .error(_) :
                completionHandler(Response.error("Error occurred while retreiving data"))
            default :
                break
            }
            
        })
    }
}
