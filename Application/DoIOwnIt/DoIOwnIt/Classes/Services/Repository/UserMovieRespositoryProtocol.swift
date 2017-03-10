//
//  UserMovieRespositoryProtocol.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/7/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

enum UserMovieOperationType {
    case saveusermovie
    case getusermovie
    case removeusermovie
}

protocol UserMovieRespositoryProtocol {
    func saveUserMovie(movieId : Int, title : String, posterPath : String, releasedDate : String,storageMethods : [StorageType : StorageMethod], completionHandler : @escaping (_ response : Response<Any>) -> ())
    func getUserMovies(completionHandler : @escaping (_ response : Response<Any>) -> ())
    func removeUserMovie(movieId : Int, completionHandler : @escaping (_ response : Response<Any>) -> ())
}
