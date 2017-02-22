//
//  NetworkOperation.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/20/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import Alamofire

class NetworkOperation: AsynchronousOperation {
    var url : String?
    var method : HTTPMethod = .get
    var parameters : [String : Any] = [:]
    var completionHandler : (_ httpResponse : Response<Any>) -> () = { response in }
    
    var httpRquestProtocol : HTTPRequestProtocol!
    
    override init() {
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        if httpRquestProtocol != nil {
            switch self.method {
            case .get :
                httpRquestProtocol.get(url: url!, parameters: parameters, completionHandler: { response in
                    self.completionHandler(response)
                    self.completeOperation()
                })
            case .post :
                httpRquestProtocol.post(url: url!, parameters: parameters, completionHandler:{ response in
                    self.completionHandler(response)
                    self.completeOperation()
                })
            case .put :
                httpRquestProtocol.put(url: url!, parameters: parameters, completionHandler: { response in
                    self.completionHandler(response)
                    self.completeOperation()
                })
            case .delete :
                httpRquestProtocol.delete(url: url!, parameters: parameters, completionHandler: { response in
                    self.completionHandler(response)
                    self.completeOperation()
                })
            default : break
                
            }
        }
        
        
    }
    
    
}
