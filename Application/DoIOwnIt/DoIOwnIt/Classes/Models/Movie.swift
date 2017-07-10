//
//  Model.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/21/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit

class Movie: NSObject {
    var id : Int?
    var title : String?
    var posterPath : String?
    var releasedDate : String?
    var voteAverage : Double?
    var overview : String?
    var castList : [Int : Cast]?
    var crewList : [Int : Crew]?
    var storageMethods : [StorageType : StorageMethod]?
    var isOwned : Bool?
    
    init(withDictionary dictionary : [String : Any]){
        if let id = dictionary["id"] as? Int? {
            self.id = id
        }
        if let title = dictionary["title"] as? String? {
            self.title = title
        }else{
            self.title = ""
        }
        if let posterPath = dictionary["poster_path"] as? String? {
            self.posterPath = posterPath
        }else{
            self.posterPath = ""
        }
        if let releasedDate = dictionary["release_date"] as? String? {
            self.releasedDate = releasedDate
        }else{
            self.releasedDate = ""
        }
        if let voteAverage = dictionary["vote_average"] as? Double? {
            self.voteAverage = voteAverage
        }else{
            self.voteAverage = 0
        }
        if let overview = dictionary["overview"] as? String? {
            self.overview = overview
        }else{
            self.overview = ""
        }
        self.isOwned = false
        storageMethods = [:]
        if let storageMethodsString = dictionary["storage_methods"] as! String? {
            let storageMethodsDictionary = JSON.convertToDictionary(text: storageMethodsString)
            
            for (_, dictionary) in storageMethodsDictionary as! [String : [String : String]] {
                for (storageType, storageMethodString) in dictionary {
                    storageMethods?[StorageType(rawValue:storageType)!] = StorageMethod(storageType : StorageType(rawValue:storageType)!, methods : storageMethodString)
                }
            }
        }
        
    }
    
    init(id : Int, title : String, posterPath : String, releasedDate : String, storageMethods : [StorageType : StorageMethod] = [:]){
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releasedDate = releasedDate
        self.storageMethods = storageMethods
    }
    
    func toDictionary() -> [String : Any] {
        var dictionary : [String : Any] = [:]
        if self.id != nil {
            dictionary["id"] = self.id
        }
        if self.title != nil {
            dictionary["title"] = self.title?.lowercased()
        }
        if self.posterPath != nil {
            dictionary["poster_path"] = self.posterPath
        }
        if self.releasedDate != nil {
            dictionary["release_date"] = self.releasedDate
        }
        if self.storageMethods != nil {
            var serialized : [String : Any] = [:]
            for (type,method) in storageMethods! {
                serialized[type.rawValue] = method.toDictionary()
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: serialized, options: [])
                
                let serializedStorageMethods = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                
                log.debug("serializedStorageMethods \(serializedStorageMethods)")
                dictionary["storage_methods"] = serializedStorageMethods
                
                
                
            } catch {
                print(error.localizedDescription)
            }
        }
        return dictionary
    }
    
}
