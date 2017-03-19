//
//  LoginViewController.swift
//  ClubAnimal
//
//  Created by HenrySu on 3/18/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit
import FBSDKLoginKit


class LoginViewController: UIViewController {

    
    @IBOutlet weak var btnFbLogin: UIButton!
    
    var fbLoginSuccess = false

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if FBSDKAccessToken.current() != nil {
            FBManager.getFBUserData(completionHandler: {
                print("FBTOKEN VALID")
//                self.btnFbLogin.setTitle("Continue as \(User.currentUser.email!)", for: .normal)
                
            })
        }

        print("VIEW DID LOAD")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if FBSDKAccessToken.current() != nil && fbLoginSuccess == true {
            performSegue(withIdentifier: "HomeSegue", sender: self)
        }
    }

    @IBAction func touchFacebookLogin(_ sender: Any) {
        if FBSDKAccessToken.current() != nil {
            fbLoginSuccess = true
            self.viewDidAppear(true)
            
        }
        else {
            FBManager.shared.logIn(
                withReadPermissions: ["public_profile", "email"],
                from: self,
                handler: { (result, error) in
                    
                    if error == nil {
                        
                        FBManager.getFBUserData(completionHandler: {
                            self.fbLoginSuccess = true
                            self.viewDidAppear(true)
                        })
                    }
            })
        }

    }

    

}
