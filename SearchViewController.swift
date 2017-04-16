//
//  SecondViewController.swift
//  Club Animal
//
//  Created by HenrySu on 3/9/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "搜尋"
        
        searchBar.backgroundImage = UIImage()

    }

}

