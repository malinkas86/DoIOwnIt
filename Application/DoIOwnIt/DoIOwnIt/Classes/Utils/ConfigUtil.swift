//
//  ConfigUtil.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/20/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class ConfigUtil: NSObject {
    static let sharedInstance = ConfigUtil()
    
    
    var movieDBBaseURL : String?
    var movieDBApiKey : String?
    var movieDBImageBaseURL : String?
    
    private override init() {
        super.init()
        //read values configured in the desired config file
        readValuesFromConfig()
    }
    /**
     * Read values configured in the desired config file
     * and assign them to the defined properties
     **/
    private func readValuesFromConfig(){
        var plistDictionary: NSDictionary?
        var plistName = "config_default"
        #if DEVELOPMENT
            plistName = "config_default_dev"
        #endif
        if let path = Bundle.main.path(forResource: plistName, ofType: "plist") {
            plistDictionary = NSDictionary(contentsOfFile: path)
        }
        if let configDictionary = plistDictionary!["config"] as! [String : String]! {
            
            movieDBBaseURL = configDictionary["movieDBBaseURL"] ?? ""
            movieDBApiKey = configDictionary["movieDBApiKey"] ?? ""
            movieDBImageBaseURL = configDictionary["movieDBImageBaseURL"] ?? ""
        }
    }
}
