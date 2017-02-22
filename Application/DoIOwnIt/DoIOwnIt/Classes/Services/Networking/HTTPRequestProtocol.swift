//
//  HTTPRequestProtocol.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/20/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import Foundation
enum NetworkError : Error {
    case serverError
    case emptyError
}

protocol HTTPRequestProtocol {
    func get(url : String, parameters : [String : Any], completionHandler : @escaping (_ httpResponse : Response<Any>) -> ())
    func post(url : String, parameters : [String : Any], completionHandler : @escaping (_ httpResponse : Response<Any>) -> ())
    func put(url : String, parameters : [String : Any], completionHandler : @escaping (_ httpResponse : Response<Any>) -> ())
    func delete(url : String, parameters : [String : Any], completionHandler : @escaping (_ httpResponse : Response<Any>) -> ())
}
