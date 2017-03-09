//
//  UserMovieManagerProtocol.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/9/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

protocol UserMovieManagerProtocol {
    func getUserMovies(completionHandler : @escaping (Response<Any>) -> ())
}
