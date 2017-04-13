//
//  User.swift
//  ClubAnimal
//
//  Created by HenrySu on 3/18/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    
    var name: String?
    var email: String?
    var fbuid: String?
    var pictureURL: String?
    var objectId: String?
    var isNewUser = true
    
//    var school
    
    static let currentUser = User()
    
    func setInfo(json: JSON) {
        self.name = json["name"].string
        self.email = json["email"].string
        self.fbuid = json["id"].string
        
        let image = json["picture"].dictionary
        let imageData = image?["data"]?.dictionary
        self.pictureURL = imageData?["url"]?.string
        
    }
    
    func setObjectId(_ objectId: String) {
        self.objectId = objectId
    }
    
    func setIsNewUser(_ isNewUser: Bool) {
        self.isNewUser = isNewUser
    }
    
    
    func resetInfo() {
        self.name = nil
        self.email = nil
        self.fbuid = nil
        self.objectId = nil
        self.isNewUser = true
        self.pictureURL = nil
    }
    
    
}
