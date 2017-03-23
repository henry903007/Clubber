//
//  FirstViewController.swift
//  Club Animal
//
//  Created by HenrySu on 3/9/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class BoardViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    weak var currentViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "看板"

        // handle segment control's view switching
        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "boardRecommendVC")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
        
        // if user is logged in directly, get the user data from Facebook
        if User.currentUser.name == nil {
            FBManager.getFBUserData(completionHandler: {
                print("Get FB data in BoardVC")
                let defaults = UserDefaults.standard
                defaults.set(FBSDKAccessToken.current().expirationDate,
                             forKey: "FBAccessTokenExpirationDate")
                
            })
        }
        
        
    }

    
    @IBAction func segmentIndexSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "boardRecommendVC")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        } else {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "boardCategoryVC")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController
        }
    }

    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        self.addChildViewController(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5,
                       animations: {
                        newViewController.view.alpha = 1
                        oldViewController.view.alpha = 0
                        },
                       completion: { finished in
                        oldViewController.view.removeFromSuperview()
                        oldViewController.removeFromParentViewController()
                        newViewController.didMove(toParentViewController: self)
                        })
    }
}


