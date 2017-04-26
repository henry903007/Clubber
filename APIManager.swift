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

    
    // API - Login
    func login(fbuid: String, completionHandler: @escaping (NSError?) -> Void ) {
        
        let path = "/login/"
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
                self.sessionToken = jsonData["sessionToken"].string!
//                User.currentUser.setObjectId(jsonData["objectId"].string!)
                
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

    // API - Logout
    func logout(completionHandler: @escaping (NSError?) -> Void ) {
        
        let path = "/logout/"
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
    
    // API - Get user's data
    func getUserData(completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "/users/me/"
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

    
    // API - Get the list of culb's categories
    func getClubCategories(completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "/classes/types/"
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
    
    // API - Get all events
    func getClubEvents(completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "/classes/events/"
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
    
    // API - Get events by category ID
    func getClubEvents(byCategoryId categoryId: String, completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "/search/events"
        let url = baseURL!.appendingPathComponent(path)
        
        let parameters: Parameters = ["typeId": categoryId]

        
        Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: HEADERS_WITH_SESSION_KEY)
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
    
    
    // API - Get an event's detail data
    func getEventData(byEventId eventId: String, completionHandler: @escaping (JSON) -> Void ) {
        
        let path = "/classes/events/\(eventId)"
        let url = baseURL!.appendingPathComponent(path)
        
        let parameters: Parameters = ["includes": "types,users,schools,clubs"]

        
        Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: HEADERS_WITH_SESSION_KEY)
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
    
    // API - Favorite an event
    func addFavoiteEvent(userId: String, eventId: String, completionHandler: @escaping () -> Void ) {
        
        let path = "users/\(userId)/events/\(eventId)"
        let url = baseURL!.appendingPathComponent(path)
        
        
        Alamofire.request(url!, method: .post, parameters: nil, encoding: URLEncoding.default, headers: HEADERS_WITH_SESSION_KEY)
            .responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success:
                    completionHandler()
                    break
                    
                case .failure:
                    completionHandler()
                    break
                }
            })
    }
    
    
    // API - Unfavorite an event
    func deleteFavoiteEvent(userId: String, eventId: String, completionHandler: @escaping () -> Void ) {
        
        let path = "users/\(userId)/events/\(eventId)"
        let url = baseURL!.appendingPathComponent(path)
        
        
        Alamofire.request(url!, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: HEADERS_WITH_SESSION_KEY)
            .responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success:
                    completionHandler()
                    break
                    
                case .failure:
                    completionHandler()
                    break
                }
            })
    }
    
    
    
    
    
    
}
