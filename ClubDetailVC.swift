//
//  ClubDetailVC.swift
//  Clubber
//
//  Created by HenrySu on 4/26/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

class ClubDetailVC: UIViewController {

    @IBOutlet weak var lbSchool: UILabel!
    @IBOutlet weak var lbClub: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    
    @IBOutlet weak var imgThumbnail: UIImageView!
    
    @IBOutlet weak var lbDescription: UITextView!
    
    @IBOutlet weak var lbContactInfo: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
