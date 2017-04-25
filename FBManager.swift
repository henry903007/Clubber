//
//  FBManager.swift
//  ClubAnimal
//
//  Created by HenrySu on 3/18/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import SwiftyJSON

class FBManager {
    
    static let shared = FBSDKLoginManager()
    
    public class func getFBUserData(completionHandler: @escaping () -> Void ) {
        
        if FBSDKAccessToken.current() != nil {
            
            FBSDKGraphRequest(graphPath: "me",
                              parameters: ["fields": "name, email, picture.type(large)"])
                .start(completionHandler: { (connection, result, error) in
                    
                    if error == nil {
                        
                        let json = JSON(result!)
                        
                        User.currentUser.setInfoFromFacebook(facebookJson: json)
                        
                        completionHandler()
                    }
                    
                })
            
        }
    }
}
