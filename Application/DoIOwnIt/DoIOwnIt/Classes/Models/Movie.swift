//
//  Model.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/21/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class Movie: NSObject {
    var id : Int?
    var title : String?
    var posterPath : String?
    var releasedDate : String?
    var voteAverage : Double?
    var overview : String?
    var castList : [Int : Cast]?
    var crewList : [Int : Crew]?
    
    init(withDictionary dictionary : [String : Any]){
        if let id = dictionary["id"] as? Int? {
            self.id = id
        }
        if let title = dictionary["title"] as? String? {
            self.title = title
        }else{
            self.title = ""
        }
        if let posterPath = dictionary["poster_path"] as? String? {
            self.posterPath = posterPath
        }else{
            self.posterPath = ""
        }
        if let releasedDate = dictionary["released_date"] as? String? {
            self.releasedDate = releasedDate
        }else{
            self.releasedDate = ""
        }
        if let voteAverage = dictionary["vote_average"] as? Double? {
            self.voteAverage = voteAverage
        }else{
            self.voteAverage = 0
        }
        if let overview = dictionary["overview"] as? String? {
            self.overview = overview
        }else{
            self.overview = ""
        }
        
    }
    
}
