//
//  Response.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/16/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import Foundation

enum Response<T> {
    case success(T)
    case error(T)
}
