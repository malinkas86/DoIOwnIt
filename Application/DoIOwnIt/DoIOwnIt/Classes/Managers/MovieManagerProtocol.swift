//
//  MovieManagerProtocol.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/20/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import Foundation

protocol MovieManagerProtocol {
    
    func searchMovies(query : String , page : Int, completionHandler : @escaping (_ response : Response<Any>) -> ())
    func getMovieDetailsById(id : Int, completionHandler : @escaping (_ response : Response<Any>) -> ())
}
