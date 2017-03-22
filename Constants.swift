//
//  Constants.swift
//  ClubAnimal
//
//  Created by HenrySu on 3/21/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import Foundation
import Alamofire

let defaults = UserDefaults.standard

let BASE_URL: String = "http://172.104.34.50:2000/v1/"

let HEADERS: HTTPHeaders = [
    "X-Parse-Application-Id": "ClubsProject",
    "Content-Type": "application/json"
]

let HEADERS_WITH_SESSION_KEY: HTTPHeaders = [
    "X-Parse-Application-Id": "ClubsProject",
    "X-Parse-Session-Token": defaults.string(forKey: "sessionToken") ?? "",
    "Content-Type": "application/json"
]
