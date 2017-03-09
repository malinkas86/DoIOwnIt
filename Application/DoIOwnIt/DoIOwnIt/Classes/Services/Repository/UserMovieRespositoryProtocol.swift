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
}

protocol UserMovieRespositoryProtocol {
    func saveUserMovie(movieId : Int, title : String, posterPath : String, releasedDate : String,storageMethods : [StorageType : StorageMethod], completionHandler : @escaping (_ response : Response<Any>) -> ())
}
