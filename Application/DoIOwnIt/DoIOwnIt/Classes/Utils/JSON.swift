//
//  JSON.swift
//  DoIOwnIt
//
//  Created by Malinka S on 3/8/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class JSON: NSObject {

    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
