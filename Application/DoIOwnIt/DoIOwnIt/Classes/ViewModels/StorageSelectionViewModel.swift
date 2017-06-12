//
//  StorageSelectionViewModel.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/6/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class StorageSelectionViewModel: NSObject {
    let storageManager = StorageManager(userMovieRepository: UserMovieRepository())
    let userMovieManager = UserMovieManager(userMovieRepository: UserMovieRepository())
    
    func saveStoragePreference(movieId : Int, title : String, posterPath : String, releasedDate : String, storageMethods : [StorageType : String], completionHandler : @escaping (_ response : Response<Any>) -> ()){
        storageManager.saveMovieStoragePreferences(movieId: movieId, title: title, posterPath: posterPath, releasedDate: releasedDate, storageMethods: storageMethods, completionHandler: {response in
            
            switch response {
            case .success(_):
                self.userMovieManager.getUserMovies(completionHandler: { userMovieResponse in
                    switch userMovieResponse {
                    case let .success(movies):
                        userMovies = movies as! [Movie]
                    case .error(_):
                        completionHandler(Response.error("Error occurred while retreiving data"))
                    }
                })
                completionHandler(Response.success(true))
            case .error(_):
                completionHandler(Response.error(false))
            }
        })
    }

}
