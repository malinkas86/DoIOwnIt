//
//  StorageSelectionViewModel.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/6/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import Firebase

class StorageSelectionViewModel: NSObject {
    let storageManager = StorageManager(userMovieRepository: UserMovieRepository())
    let userMovieManager = UserMovieManager(userMovieRepository: UserMovieRepository())
    
    func saveStoragePreference(movieId : Int, title : String, posterPath : String, releasedDate : String, storageMethods : [StorageType : String], completionHandler : @escaping (_ response : Response<Any>) -> ()){
        storageManager.saveMovieStoragePreferences(movieId: movieId, title: title, posterPath: posterPath, releasedDate: releasedDate, storageMethods: storageMethods, completionHandler: {response in
            
            switch response {
            case .success(_):
                Analytics.logEvent("save_storage_preferences", parameters: ["status": "success",
                                                                            "movie_id": movieId,
                                                                            "title": title,
                                                                            "storage_methods": storageMethods])
                Analytics.logEvent("add_movie", parameters: ["status": "success",
                                                                "movie_id": movieId])
                self.userMovieManager.getUserMovies(completionHandler: { userMovieResponse in
                    switch userMovieResponse {
                    case let .success(movies):
                        userMovies = movies as! [Movie]
                        completionHandler(Response.success(true))
                    case .error(_):
                        completionHandler(Response.error("Error occurred while retreiving data"))
                    }
                })
                
            case .error(_):
                Analytics.logEvent("save_storage_preferences", parameters: ["status": "failure",
                                                                            "movie_id": movieId,
                                                                            "title": title])
                Analytics.logEvent("add_movie", parameters: ["status": "success",
                                                                "movie_id": movieId])
                completionHandler(Response.error(false))
            }
        })
    }

}
