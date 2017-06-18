//
//  MovieListViewModel.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/20/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import Firebase

class MovieListViewModel: NSObject {
    var currentPage : Int = 1
    var page : Int?
    var totalResults : Int?
    var totalPages : Int?
    var movies : [Movie] = []
    var localUserMovies : [Int : String] = [:]
    let userMovieManager = UserMovieManager(userMovieRepository: UserMovieRepository())
    let movieManager = MovieManager(httpRequest: HTTPRequest())
    
    func searchMovies(query : String, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        self.localUserMovies = [:]
        for movie in userMovies {
            self.localUserMovies[movie.id!] = movie.title
        }
        
        if currentPage == 1 || currentPage < totalPages! {
            
            self.movieManager.searchMovies(query: query, page: self.currentPage, completionHandler: { response in
                switch response {
                case let .success(movieList as MovieList):
                    self.currentPage = self.currentPage + 1
                    self.page = movieList.page
                    self.totalResults = movieList.totalResults
                    self.movies = self.movies + movieList.movies!
                    log.info("movie count\(self.movies.count)")
                    Analytics.logEvent("movie_search", parameters: ["status": "success",
                                                             "query": query,
                                                             "page": self.currentPage - 1,
                                                             "record_count": movieList.totalResults ?? "0"])
                    self.totalPages = movieList.totalPages
                    completionHandler(Response.success(true))
                case .error(_) :
                    Analytics.logEvent("movie_search", parameters: ["status": "failure",
                                                                    "query": query])
                    completionHandler(Response.error("Error occurred while retreiving data"))
                default :
                    break
                }
                
            })
        }else{
            completionHandler(Response.error("Reached end of pages"))
        }
        
        
    }
    
    
}
