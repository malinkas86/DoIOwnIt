//
//  UserMovieRepository.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/7/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import Firebase

enum RepositoryError<T> : Error {
    case objectnotfound(T)
}

class UserMovieRepository: UserMovieRespositoryProtocol {
    
    private var ref: DatabaseReference!
    
    func saveUserMovie(movieId: Int, title: String, posterPath: String,
                       releasedDate: String, storageMethods: [StorageType : StorageMethod],
                       completionHandler: @escaping (_ response: Response<Any>) -> ()) {
        
        self.ref = Database.database().reference()
        self.ref.keepSynced(true)
        
        let user : User = (Auth.auth().currentUser)!
        let movie = Movie(id: movieId, title: title, posterPath: posterPath, releasedDate: releasedDate, storageMethods : storageMethods)
        self.ref.child("user-movies").child("\(user.uid)").child(String(format : "%d",movie.id!)).setValue(movie.toDictionary())
        completionHandler(Response.success(user))
    }
    
    func getUserMovies(completionHandler: @escaping (_ response: Response<Any>) -> ()) {
        
        self.ref = Database.database().reference()
        self.ref.keepSynced(true)
        if let user = Auth.auth().currentUser {
            
            ref.child("user-movies").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                var movies = [Movie]()
                if let moviesDictionary = snapshot.value as? [String : Any] {
                    
                    for (_, movieDictionary) in moviesDictionary {
                        
                        movies.append(Movie(withDictionary: movieDictionary as! [String : Any]))
                        
                    }
                }
                completionHandler(Response.success(movies))
                
            }) { (error) in
                completionHandler(Response.error(error))
            }
        }
    }
    
    
    func getUserMovies(byQuery searchQuery: String,
                       completionHandler: @escaping (_ response: Response<Any>) -> ()) {
        
        self.ref = Database.database().reference()
        self.ref.keepSynced(true)
        if let user = Auth.auth().currentUser {
            
            let query = ref.child("user-movies").child(user.uid).queryOrdered(byChild: "title").queryStarting(atValue: searchQuery.lowercased()).queryEnding(atValue: searchQuery.lowercased()+"\u{f8ff}")
            query.observe(.value, with: { (snapshot) in
                var movies = [Movie]()
                for childSnapshot in snapshot.children {
                    
                    if let childSnapshot = childSnapshot as? DataSnapshot,
                        let movieDictionary = childSnapshot.value as? [String : Any] {
                        movies.append(Movie(withDictionary: movieDictionary))
                    }
                }
                completionHandler(Response.success(movies))
            })
        }
    }
    
    func getUserMovieById(movieId: Int,
                          completionHandler: @escaping (_ response: Response<Any>) -> ()) {
        
        self.ref = Database.database().reference()
        self.ref.keepSynced(true)
        if let user = Auth.auth().currentUser {
            ref.child("user-movies").child(user.uid).child("\(movieId)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let movieDictionary = snapshot.value as? [String : Any] {
                    
                    completionHandler(Response.success(Movie(withDictionary: movieDictionary)))
                }else{
                    completionHandler(Response.error(RepositoryError.objectnotfound("Movie not found")))
                }
            }) { (error) in
                completionHandler(Response.error(error))
            }
        }
        
    }
    
    func removeUserMovie(movieId: Int,
                         completionHandler: @escaping (_ response: Response<Any>) -> ()) {
        
        self.ref = Database.database().reference()
        self.ref.keepSynced(true)
        if let user = Auth.auth().currentUser {
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
