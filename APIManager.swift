//
//  APIManager.swift
//  ClubAnimal
//
//  Created by HenrySu on 3/21/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import FBSDKLoginKit

class APIManager {
    
    static let shared = APIManager()

    let baseURL = NSURL(string: BASE_URL)

    var sessionToken = ""     // access token

//    var refreshToken = ""
//    var expired = Date()

    
    func login(fbuid: String, completionHandler: @escaping (NSError?) -> Void ) {
        
        let path = "v1/api/login/"
        let url = baseURL!.appendingPathComponent(path)
        
        let params: Parameters = [
            "fb_uid": fbuid,
            "fb_token": FBSDKAccessToken.current().tokenString,
        ]

        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: HEADERS)
            .responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                
                let jsonData = JSON(value)
                print(jsonData)
                self.sessionToken = jsonData["sessionToken"].string!
                User.currentUser.setObjectId(jsonData["objectId"].string!)
                
                if jsonData["username"] != JSON.null {
                    User.currentUser.setIsNewUser(false)
                }
                
                completionHandler(nil)
                break
                
            case .failure(let error):
                completionHandler(error as NSError?)
                break
            }
            
        }
    }

    
}
