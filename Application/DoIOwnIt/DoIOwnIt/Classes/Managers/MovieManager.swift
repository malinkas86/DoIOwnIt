//
//  MovieManager.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/20/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class MovieManager: MovieManagerProtocol {
    lazy var movieOperationQueue : OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.name = "movieOperationQueue"
        return queue
        }()
    var httpRequest : HTTPRequestProtocol?
    
    init(httpRequest : HTTPRequestProtocol) {
       self.httpRequest = httpRequest
    }
    func searchMovies(query : String , page : Int, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        let operation = NetworkOperation()
        operation.method = .get
        operation.httpRquestProtocol = httpRequest
        operation.url = APIList.MOVIE_SEARCH_API
        operation.parameters = ["query": query, "page" : String(page), "include_adult" : "true", "language" : "en-US", "api_key" : ConfigUtil.sharedInstance.movieDBApiKey!]
        operation.completionHandler = { response in
            switch response {
            case let .success(responseData):
                let movieList = MovieList(withDictionary: responseData as! [String : Any])
                completionHandler(Response.success(movieList))
            case let .error(error):
                completionHandler(Response.error(error))
            }
            
            
        }
        movieOperationQueue.addOperation(operation)
    }
    
    func getMovieDetailsById(id : Int, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        let operation = NetworkOperation()
        operation.method = .get
        operation.httpRquestProtocol = httpRequest
        print("url \(APIList.MOVIE_DETAILS_API)")
        let url = "\(APIList.MOVIE_DETAILS_API)\(id)"
        operation.url = url
        operation.parameters = ["api_key" : ConfigUtil.sharedInstance.movieDBApiKey!]
        operation.completionHandler = { response in
            switch response {
            case let .success(responseData):
                let movie = Movie(withDictionary: responseData as! [String : Any])
                
                self.getMovieCreditsById(id: movie.id!, completionHandler: { creditResponse in
                    switch creditResponse {
                    case let .success(creditResponseData as [String : Any]) :
                        movie.castList = creditResponseData["cast"] as! [Int : Cast]?
                        movie.crewList = creditResponseData["crew"] as! [Int : Crew]?
                        completionHandler(Response.success(movie))
                    case let .error(error) :
                        completionHandler(Response.error(error))
                    default : break
                    }
                })
                
                
            case let .error(error):
                completionHandler(Response.error(error))
            }
            
            
        }
        movieOperationQueue.addOperation(operation)
    }
    
    func getMovieCreditsById(id : Int, completionHandler : @escaping (_ response : Response<Any>) -> ()){
        let operation = NetworkOperation()
        operation.method = .get
        operation.httpRquestProtocol = httpRequest
        let url = String(format: APIList.MOVIE_CREDITS_API, id)
        operation.url = url
        operation.parameters = ["api_key" : ConfigUtil.sharedInstance.movieDBApiKey!]
        operation.completionHandler = { response in
            switch response {
            case let .success(responseData):
                var castList : [Int : Cast] = [:]
                var crewList : [Int : Crew] = [:]
                let responseDataDictionary = responseData as! [String : Any]
                if let castDictionaryList = responseDataDictionary["cast"] as! [[String : Any]]! {
                    for castDictionary in castDictionaryList {
                        let cast = Cast(withDictionary: castDictionary)
                        castList[cast.order!] = cast
                    }
                }
                if let crewDictionaryList = responseDataDictionary["crew"] as! [[String : Any]]! {
                    for crewDictionary in crewDictionaryList {
                        let crew = Crew(withDictionary: crewDictionary)
                        if crew.department == "Directing" {
                            crewList[crew.id!] = crew
                        }
                        
                    }
                }

                completionHandler(Response.success(["cast" : castList, "crew" : crewList]))
            case let .error(error):
                completionHandler(Response.error(error))
            }
            
            
        }
        movieOperationQueue.addOperation(operation)
    }
}
