//
//  MovieList.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/21/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class MovieList: NSObject {
    var page : Int?
    var totalResults : Int?
    var totalPages : Int?
    var movies : [Movie]?
    
    init(withDictionary dictionary : [String : Any]){
        if let page = dictionary["page"] as! Int! {
            self.page = page
        }
        if let totalResults = dictionary["total_results"] as! Int! {
            self.totalResults = totalResults
        }
        if let totalPages = dictionary["total_pages"] as! Int! {
            self.totalPages = totalPages
        }
        movies = []
        if let movieDictionaryArray = dictionary["results"] as! [[String : Any]]! {
            for movieDictionary in movieDictionaryArray {
                movies?.append(Movie(withDictionary: movieDictionary))
            }
        }
    }

}
