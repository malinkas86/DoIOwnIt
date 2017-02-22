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
    func searchBooks(query : String , page : Int, completionHandler : @escaping (_ response : Response<Any>) -> ()){
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
}
