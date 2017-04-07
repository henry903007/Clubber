//
//  FeedbackViewController.swift
//  ClubAnimal
//
//  Created by HenrySu on 3/28/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "意見回饋"
    }

    @IBAction func touchSubmit(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)

    }


}
