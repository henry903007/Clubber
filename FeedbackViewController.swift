//
//  FeedbackViewController.swift
//  ClubAnimal
//
//  Created by HenrySu on 3/28/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var textFieldTitle: UITextField!
    
    @IBOutlet weak var feedbackViewBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "意見回饋"
        hideKeyboardWhenTappedAround()

        
//        createGradientLayer()

        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textFieldTitle.frame.height))
        textFieldTitle.leftView = paddingView
        textFieldTitle.leftViewMode = UITextFieldViewMode.always
        
    }

    @IBAction func touchSubmit(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)

    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = feedbackViewBackground.bounds
        
        let color1 = UIColor(red:0.21, green:0.58, blue:0.71, alpha:1.0)
        let color2 = UIColor(red:0.38, green:0.92, blue:0.87, alpha:1.0)
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        
        feedbackViewBackground.layer.addSublayer(gradientLayer)
    }

    
    

}

extension FeedbackViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "什麼想說的都可以唷～") {
            textView.text = ""
            textView.textColor = UIColor(red:0.21, green:0.58, blue:0.71, alpha:1.0)
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text == "") {
            textView.text = "什麼想說的都可以唷～"
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}
