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
    
    func getUserMovies(completionHandler : @escaping (_ response : Response<Any>) -> ()) {
        
        self.ref = FIRDatabase.database().reference()
        
        if let user = FIRAuth.auth()?.currentUser {
            ref.child("user-movies").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                var movies = [Movie]()
                if let moviesDictionary = snapshot.value as? [String : Any] {
                    
                    for (_, movieDictionary) in moviesDictionary {
                        
                        movies.append(Movie(withDictionary: movieDictionary as! [String : Any]))
                        
                    }
                }
                completionHandler(Response.success(movies))
                
                
                // ...
            }) { (error) in
                completionHandler(Response.error(error))
            }
        }
    }
    
    func removeUserMovie(movieId : Int, completionHandler : @escaping (_ response : Response<Any>) -> ()) {
        
        self.ref = FIRDatabase.database().reference()
        
        if let user = FIRAuth.auth()?.currentUser {
            ref.child("user-movies").child(user.uid).child("\(movieId)").removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    completionHandler(Response.error(error!))
                }else{
                    completionHandler(Response.success(true))
                }
            })
            
        }
    }
}
