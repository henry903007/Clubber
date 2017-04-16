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
    var category: String?
    
    var club: String?
    var school: String?
    
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
        

//        TODO: Get school and club
//        let categoryData = json["types"].dictionary
//        self.category = clubData?["name"]?.string
//        
//        let clubData = json["clubs"].dictionary
//        self.club = clubData?["name"]?.string

        
    }

    
    func setCollected(_ isCollected: Bool) {
        self.isCollected = isCollected
    }
    
    
}
