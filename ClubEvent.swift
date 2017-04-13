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
    



    
    init(json: JSON) {
        self.objectId = json["objectId"].string
        self.name = json["name"].string
        self.location = json["localtion"].string
        self.imageURL = json["imgURL"].string
        
        let startDateData = json["startAt"].dictionary
        if let startDateString = startDateData?["iso"]?.string {
            (self.startDate, self.startTime) = convertDateFormat(dateString: startDateString)
        }
        
        let endDateData = json["endAt"].dictionary
        if let endDateString = endDateData?["iso"]?.string {
            (self.endDate, self.endTime) = convertDateFormat(dateString: endDateString)
        }
        

        
//        let categoryData = json["types"].dictionary
//        self.category = clubData?["name"]?.string
//        
//        let clubData = json["clubs"].dictionary
//        self.club = clubData?["name"]?.string
//        

        
    }
    
    func convertDateFormat(dateString: String) -> (date: String?, time: String?) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateString)!
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let date_str = dateFormatter.string(from:date)
        
        dateFormatter.dateFormat = "HH:mm"
        let time_str = dateFormatter.string(from:date)
        
        return (date_str, time_str)

 
    }
}
