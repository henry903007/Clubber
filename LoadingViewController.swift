//
//  LoadingViewController.swift
//  ClubAnimal
//
//  Created by HenrySu on 4/6/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // if user is logged in directly, get the user data from Facebook
        if User.currentUser.name == nil {
            FBManager.getFBUserData(completionHandler: {
                let defaults = UserDefaults.standard
                print(defaults.string(forKey: "sessionToken") ?? "")

                defaults.set(FBSDKAccessToken.current().expirationDate,
                             forKey: "FBAccessTokenExpirationDate")
                APIManager.shared.getUserData(completionHandler: { (json) in
                    if json != nil {
                        User.currentUser.setInfo(json: json)
                    }
                    self.performSegue(withIdentifier: "HomeTabBarSegue", sender: self)
                })
                
                
            })
        }
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
