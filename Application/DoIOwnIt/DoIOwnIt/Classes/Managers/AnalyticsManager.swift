//
//  AnalyticsManager.swift
//  DoIOwnIt
//
//  Created by Malinka S on 7/16/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class AnalyticsManager: AnalyticsManagerProtocol {
    lazy var analyticsOperationQueue : OperationQueue = {
        var queue = OperationQueue()
        queue.name = "analyticsOperationQueue"
        queue.maxConcurrentOperationCount = 2
        return queue
    }()
    
    func logEvent(_ eventName: String, parameters: [String: Any]?) {
        let operation = AnalyticsOperation(analyticsOperationType: .logEvent)
        operation.eventName = eventName
        
        if let parameters = parameters {
            operation.parameters = parameters
        }
        analyticsOperationQueue.addOperation(operation)
        
    }
    
    func setUserProperty(userProperty: String, userPropertyValue: String) {
        let operation = AnalyticsOperation(analyticsOperationType: .setUserProperty)
        operation.userProperty = userProperty
        operation.userPropertyValue = userPropertyValue
        
        analyticsOperationQueue.addOperation(operation)
    }
    
    func setUserID(_ userId: String?) {
        let operation = AnalyticsOperation(analyticsOperationType: .setUserId)
        operation.userId = userId
        analyticsOperationQueue.addOperation(operation)
    }

}
