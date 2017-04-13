//
//  LoadingButton.swift
//  ClubAnimal
//
//  Created by HenrySu on 3/23/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {

    var originalButtonText: String?
    let loadingIndicator = LoadingIndicator()
    
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: UIControlState.normal)
        self.isUserInteractionEnabled = false
        
        loadingIndicator.showLoading(in: self)
    }
    
    func hideLoading() {
        self.setTitle(originalButtonText, for: UIControlState.normal)
        self.isUserInteractionEnabled = true
        loadingIndicator.stopAnimating()
    }
}
