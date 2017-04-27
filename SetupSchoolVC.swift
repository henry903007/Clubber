//
//  SetupSchoolVC.swift
//  Clubber
//
//  Created by HenrySu on 4/26/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

class SetupSchoolVC: UIViewController {

    @IBOutlet weak var btnNTU: UIButton!
    @IBOutlet weak var btnNTUST: UIButton!
    @IBOutlet weak var btnNTNU: UIButton!

    var selectedSchool: String?
    
    @IBAction func schoolLogoDidClick(_ sender: UIButton) {
        if sender.restorationIdentifier == "logo-NTU" {

            selectedSchool = "NTU"
            print("NTU")
            btnNTU.backgroundColor = UIColor.lightText
            btnNTUST.backgroundColor = UIColor.clear
            btnNTNU.backgroundColor = UIColor.clear
        }
        else if sender.restorationIdentifier == "logo-NTUST" {
            selectedSchool = "NTUST"
print("NTUST")
            btnNTU.backgroundColor = UIColor.clear
            btnNTUST.backgroundColor = UIColor.lightText
            btnNTNU.backgroundColor = UIColor.clear
        }
        else {
            selectedSchool = "NTNU"
print("NTnU")
            btnNTU.backgroundColor = UIColor.clear
            btnNTUST.backgroundColor = UIColor.clear
            btnNTNU.backgroundColor = UIColor.lightText
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SchoolSetupSegue" {
            var schoolId = ""
            
            switch selectedSchool! {
            case "NTU":
                schoolId = "L0VsEPntE3"
                User.currentUser.schoolName = "臺大"
            case "NTUST":
                schoolId = "vVmwvf1tlZ"
                User.currentUser.schoolName = "臺科大"
            case "NTNU":
                schoolId = "Qwlp2UJ9Y9"
                User.currentUser.schoolName = "臺師大"
            default:
                return false
            }
            
            User.currentUser.schoolId = schoolId

            APIManager.shared.setupSchool(userId: User.currentUser.objectId!, schoolId: schoolId, completionHandler: {})
            
            
            return true
        }
        
        return true
    }

}
