//
//  AnalyticsOperation.swift
//  DoIOwnIt
//
//  Created by Malinka S on 7/16/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import Firebase

enum AnalyticsOperationType {
    case logEvent
    case setUserProperty
    case setUserId
}

class AnalyticsOperation: AsynchronousOperation {
    
    var analyticsOperationType: AnalyticsOperationType
    var eventName: String?
    var parameters: [String: Any]?
    var userProperty: String?
    var userPropertyValue: String?
    var userId: String?
    
    public init(analyticsOperationType: AnalyticsOperationType) {
        self.analyticsOperationType = analyticsOperationType
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        switch self.analyticsOperationType {
        case .setUserProperty:
            if let userProperty = userProperty,
                let userPropertyValue = userPropertyValue {
                Analytics.setUserProperty(userPropertyValue, forName: userProperty)
            }
            self.completeOperation()
        case .logEvent:
            if let eventName = eventName,
                let parameters = parameters {
                Analytics.logEvent(eventName, parameters: parameters)
            }
            self.completeOperation()
        case .setUserId:
            Analytics.setUserID(userId)
            self.completeOperation()
        }
    }
    
}
