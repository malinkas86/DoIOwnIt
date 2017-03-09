//
//  UserMovieRepository.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/7/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import Firebase

class UserMovieRepository: UserMovieRespositoryProtocol {
    var ref: FIRDatabaseReference!
    func saveUserMovie(movieId : Int, title : String, posterPath : String, releasedDate : String,storageMethods : [StorageType : StorageMethod], completionHandler : @escaping (_ response : Response<Any>) -> ()) {
        
        self.ref = FIRDatabase.database().reference()
        
        let user : FIRUser = (FIRAuth.auth()?.currentUser)!
        let movie = Movie(id: movieId, title: title, posterPath: posterPath, releasedDate: releasedDate, storageMethods : storageMethods)
        self.ref.child("user-movies").child("\(user.uid)").child(String(format : "%d",movie.id!)).setValue(movie.toDictionary())
        completionHandler(Response.success(user))
    }
}
