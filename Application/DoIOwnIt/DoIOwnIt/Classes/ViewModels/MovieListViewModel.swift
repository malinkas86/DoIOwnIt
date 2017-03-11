//
//  MovieListViewModel.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/20/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class MovieListViewModel: NSObject {
    var currentPage : Int = 1
    var page : Int?
    var totalResults : Int?
    var totalPages : Int?
    var movies : [Movie] = []
    var userMovies : [Int : String] = [:]
    let userMovieManager = UserMovieManager(userMovieRepository: UserMovieRepository())
    let movieManager = MovieManager(httpRequest: HTTPRequest())
    
    func searchMovies(query : String, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        
        if currentPage == 1 || currentPage < totalPages! {
            
            userMovieManager.getUserMovies(completionHandler: { response in
                switch response {
                case let .success(movies as [Movie]):
                    for movie in movies {
                        self.userMovies[movie.id!] = movie.title
                    }
                    self.movieManager.searchMovies(query: query, page: self.currentPage, completionHandler: { response in
                        switch response {
                        case let .success(movieList as MovieList):
                            self.currentPage = self.currentPage + 1
                            self.page = movieList.page
                            self.totalResults = movieList.totalResults
                            self.movies = self.movies + movieList.movies!
                            log.info("movie count\(self.movies.count)")
                            self.totalPages = movieList.totalPages
                            completionHandler(Response.success(true))
                        case .error(_) :
                            completionHandler(Response.error("Error occurred while retreiving data"))
                        default :
                            break
                        }
                        
                    })
                case .error(_) :
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
