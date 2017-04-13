//
//  LoadingIndicator.swift
//  ClubAnimal
//
//  Created by HenrySu on 4/13/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

class LoadingIndicator: UIActivityIndicatorView {

    var activityIndicator: UIActivityIndicatorView!

    func showLoading(in view: UIView) {
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning(view)
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.white
        return activityIndicator
    }
    
    private func showSpinning(_ view: UIView) {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        centerActivityIndicatorInButton(view)
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton(_ view: UIView) {
        let xCenterConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        view.addConstraint(yCenterConstraint)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
