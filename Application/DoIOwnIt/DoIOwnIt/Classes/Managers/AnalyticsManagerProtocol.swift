//
//  AnalyticsManagerProtocol.swift
//  DoIOwnIt
//
//  Created by Malinka S on 7/16/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

protocol AnalyticsManagerProtocol {
    func logEvent(_ eventName: String, parameters: [String: Any]?)
    func setUserProperty(userProperty: String, userPropertyValue: String)
    func setUserID(_ userId: String?)
}
