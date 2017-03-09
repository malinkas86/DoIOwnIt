//
//  StorageManagerProtocol.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/7/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import Foundation

protocol StorageManagerProtocol {
    func saveMovieStoragePreferences(movieId : Int, title : String, posterPath : String, releasedDate : String,storageMethods : [StorageType : String], completionHandler : @escaping (_ response : Response<Any>) -> ())
}
