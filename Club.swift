//
//  Club.swift
//  Clubber
//
//  Created by HenrySu on 4/26/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import Foundation
import SwiftyJSON



class Club {
    
    var objectId: String?
    var name: String?
    
    var schoolName: String?
    var schoolId: String?
    
    var contactInfo: String?
    var description: String?

    
    init(json: JSON) {
        self.objectId = json["objectId"].string
        self.name = json["name"].string
        self.contactInfo = json["contact"].string
        self.description = json["description"].string

        if let schoolData = json["schools"].array {
            if (schoolData.count) > 0 {
                self.schoolName = schoolData[0]["name"].string
                self.schoolId = schoolData[0]["objectId"].string
            }
        }
        
    }

}
