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
        
        let path = "api/login/"
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

    func logout(completionHandler: @escaping (NSError?) -> Void ) {
        
        let path = "api/logout/"
        let url = baseURL!.appendingPathComponent(path)
        
        Alamofire.request(url!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: HEADERS_WITH_SESSION_KEY)
            .responseString { (response) in
                
                switch response.result {
                case .success:
                    print("Log out successfully")
                    completionHandler(nil)
                    break
                    
                case .failure(let error):
                    print(error)
                    completionHandler(error as NSError)
                    break
                }
        }
        
    }
    
    func getClubCategories(completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "api/classes/types/"
        let url = baseURL!.appendingPathComponent(path)
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: HEADERS_WITH_SESSION_KEY)
            .responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    completionHandler(jsonData)
                    break
                    
                case .failure:
                    completionHandler(JSON.null)
                    break
                }
            })
    }
}
