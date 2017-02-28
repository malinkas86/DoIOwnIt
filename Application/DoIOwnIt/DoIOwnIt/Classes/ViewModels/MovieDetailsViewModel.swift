//
//  MovieDetailsViewModel.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/23/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class MovieDetailsViewModel: NSObject {
    var id : Int?
    var title : String?
    var posterPath : String?
    var releasedDate : String?
    var voteAverage : Double?
    var overview : String?
    var formattedCastString : String?
    var formattedDirectorsString : String?

    let movieManager = MovieManager(httpRequest: HTTPRequest())
    func getMovie(id : Int, completionHandler : @escaping (_ httpResponse : Response<Any>) -> ()){
        
        movieManager.getMovieDetailsById(id: id, completionHandler: {response in
            switch response {
            case let .success(movie as Movie):
                self.id = movie.id
                self.title = movie.title
                self.posterPath = movie.posterPath
                self.releasedDate = movie.releasedDate
                self.voteAverage = movie.voteAverage
                self.overview = movie.overview
                
                let castList = movie.castList
                self.formattedCastString = ""
                
                for i in 0...9 {
                    if let cast = castList?[i] as Cast! {
                        self.formattedCastString = self.formattedCastString! + String(format: "%@ - %@\n", cast.character!, cast.name!)
                    }
                }
                
                self.formattedDirectorsString = ""
                for director in movie.crewList! {
                    self.formattedDirectorsString = self.formattedDirectorsString! + String(format: "%@\n", director.value.name!)
                }
                
                completionHandler(Response.success(true))
            case .error(_) :
                completionHandler(Response.error("Error occurred while retreiving data"))
            default :
                break
            }
        })
    }
}
