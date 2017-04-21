//
//  SecondViewController.swift
//  Club Animal
//
//  Created by HenrySu on 3/9/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var textStartDate: UITextField!
    @IBOutlet weak var textEndDate: UITextField!
    @IBOutlet weak var textStartTime: UITextField!
    @IBOutlet weak var textEndTime: UITextField!
    
    var editingTextField: UITextField? = nil

    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let dateFormatter = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "搜尋"
        
        initSearchBar()
        initTextFields()
        createDatePickers()
        
    }
    
    func initSearchBar() {
//        searchBar.backgroundImage = UIImage()
    }
    
    func initTextFields() {
        let now = Date()
        let aWeekFromNow = Calendar.current.date(byAdding: .day, value: 7, to: now)

        dateFormatter.dateFormat = "yyyy / MM / dd"
        textStartDate.text = dateFormatter.string(from: now)
        textEndDate.text = dateFormatter.string(from: aWeekFromNow!)

        textStartTime.text = "00:00"
        textEndTime.text = "00:00"
        
    }
    
    func createDatePickers() {
        
        // set up date picker
        datePicker.datePickerMode = .date
        dateFormatter.dateFormat = "yyyy / MM / dd"
        datePicker.addTarget(self, action: #selector(updateDateForTextField(isDoneBtnClicked:)), for: .valueChanged)
        
        // set up time picker
        timePicker.datePickerMode = .time
        dateFormatter.dateFormat = "HH:mm"
        timePicker.addTarget(self, action: #selector(updateDateForTextField(isDoneBtnClicked:)), for: .valueChanged)

        // toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        // bar button item
        let donebtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        let cancelbtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelClicked))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([cancelbtn, flexible, donebtn], animated: false)
        
        
        // assign date picker
        textStartDate.inputAccessoryView = toolBar
        textStartDate.inputView = datePicker
        textEndDate.inputAccessoryView = toolBar
        textEndDate.inputView = datePicker
        
        // assign time picker
        textStartTime.inputAccessoryView = toolBar
        textStartTime.inputView = timePicker
        textEndTime.inputAccessoryView = toolBar
        textEndTime.inputView = timePicker
        
    }
    
    func doneClicked() {
        updateDateForTextField(isDoneBtnClicked: true)
        self.view.endEditing(true)

    }
    
    func cancelClicked() {
        updateDateForTextField(isDoneBtnClicked: false)
        self.view.endEditing(true)

    }
    

    
    func updateDateForTextField(isDoneBtnClicked: Bool) {
        
        if editingTextField != nil {
            switch editingTextField! {
            case textStartDate, textEndDate:
                
                dateFormatter.dateFormat = "yyyy / MM / dd"
                editingTextField!.text = dateFormatter.string(from: datePicker.date)

            case textStartTime, textEndTime:
                dateFormatter.dateFormat = "HH:mm"
                editingTextField!.text = dateFormatter.string(from: timePicker.date)

            default:
                break
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textEndDate.text! < textStartDate.text! {
            textEndDate.text = textStartDate.text
        }
        if textEndTime.text! < textStartTime.text! {
            textEndTime.text = textStartTime.text
        }
    }
    
    // Disable editing from keyboard
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    
    
}

