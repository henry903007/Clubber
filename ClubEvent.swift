//
//  ClubEvent.swift
//  ClubAnimal
//
//  Created by HenrySu on 4/12/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import Foundation
import SwiftyJSON

class ClubEvent {
    
    var objectId: String?
    
    var name: String?
    var location: String?
    var imageURL: String?
    
    var categoryName: String?
    var categoryId: String?

    var clubName: String?
    var clubId: String?
    
    var schoolName: String?
    var schoolId: String?
    
    var startDate: String?
    var endDate: String?
    var startTime: String?
    var endTime: String?
    
    var isCollected = false
    



    
    init(json: JSON) {
        self.objectId = json["objectId"].string
        self.name = json["name"].string
        self.location = json["localtion"].string
        self.imageURL = json["imgURL"].string
        
        let startDateData = json["startAt"].dictionary
        if let startDateString = startDateData?["iso"]?.string {
            (self.startDate, self.startTime) = Utils.splitDateString(dateString: startDateString)
        }
        
        let endDateData = json["endAt"].dictionary
        if let endDateString = endDateData?["iso"]?.string {
            (self.endDate, self.endTime) = Utils.splitDateString(dateString: endDateString)
        }
        

        let categoryData = json["types"].array
        if (categoryData?.count)! > 0 {
            self.categoryName = categoryData?[0]["name"].string
            self.categoryId = categoryData?[0]["objectId"].string
        }
        let clubData = json["clubs"].array
        if (clubData?.count)! > 0 {
            self.clubName = clubData?[0]["name"].string
            self.clubId = clubData?[0]["objectId"].string
        }
        
        
        let schoolData = json["schools"].array
        if (schoolData?.count)! > 0 {
            self.schoolName = schoolData?[0]["name"].string
            self.schoolId = schoolData?[0]["objectId"].string
        }

        
    }

    
    func setCollected(_ isCollected: Bool) {
        self.isCollected = isCollected
    }
    
    
}
