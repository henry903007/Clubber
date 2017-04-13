//
//  MeViewController.swift
//  ClubAnimal
//
//  Created by HenrySu on 3/22/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {

    @IBOutlet weak var imgUserAvatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var logoutBtn: LoadingButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我"
        username.text = User.currentUser.name ?? "使用者名稱"
        Utils.loadImageFromURL(imageView: imgUserAvatar, urlString: User.currentUser.pictureURL!)
        imgUserAvatar.layer.cornerRadius = 50
        imgUserAvatar.clipsToBounds = true
    }


    @IBAction func touchLogout(_ sender: LoadingButton) {
        logoutAndPresentLoginVC()
    }

    
    

    func logoutAndPresentLoginVC() {
        
        self.logoutBtn.showLoading()
        
        APIManager.shared.logout(completionHandler: { (error) in
            
            if error == nil {
                
                let queue = DispatchQueue(label: "clubber.henrysu.logoutQueue")

                queue.sync {
                    FBManager.shared.logOut()   // will clear the FB access token
                    User.currentUser.resetInfo()
                    let defaults = UserDefaults.standard
                    defaults.set(nil, forKey: "sessionToken")
                    defaults.set(nil, forKey: "FBAccessTokenExpirationDate")
                }
                
                // Present the LoginView once you completed your login out process
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let appController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                self.present(appController, animated: true, completion: nil)
                
                
            }
            else {
                self.logoutBtn.hideLoading()
            }
            
        })

    }
    

}
