//
//  MeViewController.swift
//  ClubAnimal
//
//  Created by HenrySu on 3/22/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var logoutBtn: LoadingButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = User.currentUser.name ?? "使用者名稱"
    }

    @IBAction func touchLogout(_ sender: UIButton) {
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "LogoutSegue" {
            self.logoutBtn.showLoading()

            APIManager.shared.logout(completionHandler: { (error) in
                
                if error == nil {
                    FBManager.shared.logOut()   // will clear the FB access token
                    User.currentUser.resetInfo()
                    let defaults = UserDefaults.standard
                    defaults.set(nil, forKey: "sessionToken")
                    defaults.set(nil, forKey: "FBAccessTokenExpirationDate")
                    
                    // Re-render the LoginView once you completed your login out process
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let appController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController = appController
                }
                else {
                    self.logoutBtn.hideLoading()
                }
                
            })
            
            return false
            
        }
        
        return true
        
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
