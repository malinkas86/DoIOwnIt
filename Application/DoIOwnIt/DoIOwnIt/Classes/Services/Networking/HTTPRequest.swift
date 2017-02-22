//
//  HTTPRequest.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/20/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

import Alamofire

class HTTPRequest: HTTPRequestProtocol {
    let headers : [String : String]  = [ "Accept" : "application/json", "Content-Type" : "application/json"]
    
    func get(url : String, parameters : [String : Any], completionHandler : @escaping (_ httpResponse : Response<Any>) -> ()) {
        
        
        Alamofire.request(createUrl(url: url), method : .get, parameters : parameters, headers : headers).responseJSON { response in
            self.logResponse(response)
            if response.result.isSuccess {
                if let JSON = response.result.value {
                    log.debug("JSON: \(JSON)")
                }
                
                completionHandler(Response.success(response.result.value!))
                
            }else{
                completionHandler(Response.error(NetworkError.serverError))
                
            }
            
        }
    }
    func post(url : String, parameters : [String : Any], completionHandler : @escaping (_ httpResponse : Response<Any>) -> ()) {
        Alamofire.request(createUrl(url: url), method : .post, parameters : parameters,encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            self.logResponse(response)
            if response.result.isSuccess {
                if let JSON = response.result.value {
                    log.debug("JSON: \(JSON)")
                }
                
                completionHandler(Response.success(response.result.value!))
                
            }else{
                completionHandler(Response.error(NetworkError.serverError))
            }
            
        }
    }
    func put(url : String, parameters : [String : Any], completionHandler : @escaping (_ httpResponse : Response<Any>) -> ()) {
        Alamofire.request(createUrl(url: url), method : .put, parameters : parameters,encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            self.logResponse(response)
            if response.result.isSuccess {
                if let JSON = response.result.value {
                    log.debug("JSON: \(JSON)")
                }
                
                completionHandler(Response.success(response.result.value!))
                
            }else{
                completionHandler(Response.error(NetworkError.serverError))
            }
            
        }
    }
    func delete(url : String, parameters : [String : Any], completionHandler : @escaping (_ httpResponse : Response<Any>) -> ()) {
        Alamofire.request(createUrl(url: url), method : .delete, parameters : parameters,encoding: JSONEncoding.default, headers : headers).responseJSON { response in
            self.logResponse(response)
            if response.result.isSuccess {
                if let JSON = response.result.value {
                    log.debug("JSON: \(JSON)")
                }
                
                completionHandler(Response.success(response.result.value!))
                
            }else{
                completionHandler(Response.error(NetworkError.serverError))
            }
            
        }
    }
    
    private func createUrl(url : String) -> String {
        
        log.debug("URL "+String(format: "%@%@", ConfigUtil.sharedInstance.movieDBBaseURL!,url))
        
        return String(format: "%@%@", ConfigUtil.sharedInstance.movieDBBaseURL!,url)
        
    }
    
    private func logResponse(_ response : DataResponse<Any>){
        log.info(response.request ?? "")  // original URL request
        log.info(response.response ?? "") // HTTP URL response
        log.info(response.data ?? "")     // server data
        log.info(response.result)   // result of response serialization
        log.info(response.timeline)
    }
}
