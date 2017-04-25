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
    var schoolName: String?
    var schoolId: String?
    
    var isNewUser = true
    
//    var school
    
    static let currentUser = User()
    
    func setInfoFromFacebook(facebookJson: JSON) {
        self.objectId = facebookJson["objectId"].string
        self.name = facebookJson["name"].string
        self.email = facebookJson["email"].string
        self.fbuid = facebookJson["id"].string
        
        let image = facebookJson["picture"].dictionary
        let imageData = image?["data"]?.dictionary
        self.pictureURL = imageData?["url"]?.string
        

        
    }
    
    func setInfo(json: JSON) {
        self.objectId = json["objectId"].string

        if let schoolData = json["schools"].array {
            if (schoolData.count) > 0 {
                self.schoolName = schoolData[0]["name"].string
                self.schoolId = schoolData[0]["objectId"].string
            }
        }
        
        
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
