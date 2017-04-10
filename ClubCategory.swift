//
//  ClubType.swift
//  ClubAnimal
//
//  Created by HenrySu on 4/7/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import Foundation
import SwiftyJSON

class ClubCategory {
    
    var objectId: String?
    var name: String?

    
    init(json: JSON) {
        self.objectId = json["objectId"].string
        self.name = json["name"].string

    }

}
