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

    var categoryName: String?
    var categoryId: String?
    
    init(json: JSON) {
        self.objectId = json["objectId"].string
        self.name = json["name"].string
        self.contactInfo = json["contact"].string
        self.description = json["description"].string

        if let schoolData = json["school"].dictionary {
            self.schoolId = schoolData["objectId"]?.string
            if self.schoolId == "L0VsEPntE3" {
                schoolName = "臺大"
            }
            else if self.schoolId == "vVmwvf1tlZ" {
                schoolName = "臺科大"
            }
            else if self.schoolId == "to1Dcw7qdY" {
                schoolName = "臺師大"
            }
        }
        
        if let categoryData = json["types"].array {
            if (categoryData.count) > 0 {
                self.categoryName = categoryData[0]["name"].string
                self.categoryId = categoryData[0]["objectId"].string
            }
        }
        
    }

}
