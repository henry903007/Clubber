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
            
            btnNTU.setImage(UIImage(named: "logo-ntu"), for: .normal)
            btnNTUST.setImage(UIImage(named: "logo-ntust-unhighlight"), for: .normal)
            btnNTNU.setImage(UIImage(named: "logo-ntnu-unhighlight"), for: .normal)

        }
        else if sender.restorationIdentifier == "logo-NTUST" {
            selectedSchool = "NTUST"

            btnNTU.setImage(UIImage(named: "logo-ntu-unhighlight"), for: .normal)
            btnNTUST.setImage(UIImage(named: "logo-ntust"), for: .normal)
            btnNTNU.setImage(UIImage(named: "logo-ntnu-unhighlight"), for: .normal)
        }
        else {
            selectedSchool = "NTNU"

            btnNTU.setImage(UIImage(named: "logo-ntu-unhighlight"), for: .normal)
            btnNTUST.setImage(UIImage(named: "logo-ntust-unhighlight"), for: .normal)
            btnNTNU.setImage(UIImage(named: "logo-ntnu"), for: .normal)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "選擇學校"


        
    }


    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SchoolSetupSegue" {
            var schoolId = ""
            
            if selectedSchool == nil {
                return false
            }
            
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
