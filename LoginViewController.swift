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

    
    @IBOutlet weak var btnFbLogin: LoadingButton!
    
    let activityIndicator = UIActivityIndicatorView()
    var fbLoginSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if FBSDKAccessToken.current() != nil {
            // get user data whenever luanchs
            FBManager.getFBUserData(completionHandler: {
                /*
                APIManager.shared.login(fbuid: User.currentUser.fbuid!, completionHandler: { (error) in
                    self.fbLoginSuccess = true
                    self.viewDidAppear(true)
                })
                */
                self.btnFbLogin.setTitle("Continue as \(User.currentUser.name!)", for: .normal)
                
            })
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if FBSDKAccessToken.current() != nil && fbLoginSuccess == true {
            if User.currentUser.isNewUser {
                performSegue(withIdentifier: "InitUserSegue", sender: self)

            }
            else {
                performSegue(withIdentifier: "HomeSegue", sender: self)
            }
        }
    }

    @IBAction func touchFacebookLogin(_ sender: LoadingButton) {
        

    
        if FBSDKAccessToken.current() != nil {
            FBManager.getFBUserData(completionHandler: {
                APIManager.shared.login(fbuid: User.currentUser.fbuid!, completionHandler: { (error) in
                    if error == nil {
                        let defaults = UserDefaults.standard
                        defaults.set(APIManager.shared.sessionToken, forKey: "sessionToken")
                        defaults.set(FBSDKAccessToken.current().expirationDate,
                                     forKey: "FBAccessTokenExpirationDate")
                        
                        APIManager.shared.getUserData(completionHandler: { (json) in
                            if json != nil {
                                User.currentUser.setInfo(json: json)
                                self.fbLoginSuccess = true
                                self.viewDidAppear(true)
                            }
                        })
                    }
                })
            })
        }
            // get NEW Facebook access token then log in
        else {
            FBManager.shared.logIn(
                withReadPermissions: ["public_profile", "email"],
                from: self,
                handler: { (result, error) in
                    
                    if !(result?.isCancelled)! {
                        if error == nil {
                            sender.showLoading()
                            
                            FBManager.getFBUserData(completionHandler: {
                                APIManager.shared.login(fbuid: User.currentUser.fbuid!, completionHandler: { (error) in
                                    if error == nil {
                                        
                                        let defaults = UserDefaults.standard
                                        defaults.set(APIManager.shared.sessionToken, forKey: "sessionToken")
                                        defaults.set(FBSDKAccessToken.current().expirationDate,
                                                     forKey: "FBAccessTokenExpirationDate")
                                        
                                        APIManager.shared.getUserData(completionHandler: { (json) in
                                            if json != nil {
                                                User.currentUser.setInfo(json: json)
                                                self.fbLoginSuccess = true
                                                self.viewDidAppear(true)
                                                
                                            }
                                        })
                                        
                                    }
                                })
                            })
                        }
                    }
                    
                    
                    
            })
        }
        
    }
    

}
