//
//  SecondViewController.swift
//  Club Animal
//
//  Created by HenrySu on 3/9/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var textStartDate: UITextField!
    @IBOutlet weak var textEndDate: UITextField!
    @IBOutlet weak var textStartTime: UITextField!
    @IBOutlet weak var textEndTime: UITextField!
    @IBOutlet weak var tbvRecentSearch: UITableView!
    
    fileprivate let reuseIdentifier = "ClubEventSmallCell"
    
    let loadingView = LoadingIndicator()
    var editingTextField: UITextField? = nil
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()


    var recentSearches = [ClubEvent]()
    var searchResults = [ClubEvent]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "搜尋"
        hideKeyboardWhenTappedAround()
        
        // Setup margin of the tableview
        tbvRecentSearch.contentInset = UIEdgeInsets(top: 7, left: 0, bottom: 17, right: 0)
        loadRecentSearches()
        
        dateFormatter.dateFormat = "yyyy / MM / dd"
        timeFormatter.dateFormat = "HH:mm"
        initSearchBar()
        initTextFields()
        createDatePickers()
        
    }
    
    func initSearchBar() {
        searchBar.backgroundImage = UIImage()
    }
    
    func initTextFields() {
        let now = Date()
        let aWeekFromNow = Calendar.current.date(byAdding: .day, value: 7, to: now)

        textStartDate.text = dateFormatter.string(from: now)
        textEndDate.text = dateFormatter.string(from: aWeekFromNow!)

        textStartTime.text = "00:00"
        textEndTime.text = "00:00"
        
    }
    
    func createDatePickers() {
        
        // set up date picker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(updateDateForTextField(isDoneBtnClicked:)), for: .valueChanged)
        
        // set up time picker
        timePicker.datePickerMode = .time
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
                
                editingTextField!.text = dateFormatter.string(from: datePicker.date)

            case textStartTime, textEndTime:
                editingTextField!.text = timeFormatter.string(from: timePicker.date)

            default:
                break
            }
        }
    }
    
    
    func loadRecentSearches() {
        
            loadingView.showLoading(in: self.tbvRecentSearch)
        
        
        
        APIManager.shared.getClubEvents { (json) in
            if json != nil {
                self.recentSearches = []
                if let listClubEvents = json["results"].array {
                    
                    if listClubEvents.count != 0 {
                        for item in listClubEvents {
                            let clubEvent = ClubEvent(json: item)
                            if let eventUsers = item["users"].array {
                                if self.isCurrentUserInTheUserArray(userArray: eventUsers) {
                                    clubEvent.setCollected(true)
                                }
                                else {
                                    clubEvent.setCollected(false)
                                }
                            }
                            self.recentSearches.append(clubEvent)
                        }
                        self.tbvRecentSearch?.reloadData()
                    }
                    
                    self.loadingView.hideLoading()
                }
            }
        }
    }

    
    func isCurrentUserInTheUserArray(userArray: [JSON]) -> Bool {
        for user in userArray {
            if user["objectId"].string == User.currentUser.objectId {
                return true
            }
        }
        return false
    }
    
    


    
}

extension SearchViewController: UISearchBarDelegate {


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        searchResults = self.recentSearches.filter({ (res: ClubEvent) -> Bool in
            
            // if time fileds are not set, results will not take time fields into account
            if textStartTime.text == "00:00" && textEndTime.text == "00:00" {
                return (res.name?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil ||
                    res.schoolName?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil ||
                    res.clubName?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil ) &&
                    dateFormatter.date(from: res.startDate!)! >= dateFormatter.date(from: textStartDate.text!)! &&
                    dateFormatter.date(from: res.startDate!)! <= dateFormatter.date(from: textEndDate.text!)!
            }
            return (res.name?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil ||
                res.schoolName?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil ||
                res.clubName?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil ) &&
                dateFormatter.date(from: res.startDate!)! >= dateFormatter.date(from: textStartDate.text!)! &&
                dateFormatter.date(from: res.startDate!)! <= dateFormatter.date(from: textEndDate.text!)! &&
                timeFormatter.date(from: res.startTime!)! >= timeFormatter.date(from: textStartTime.text!)! &&
                timeFormatter.date(from: res.startTime!)! <= timeFormatter.date(from: textEndTime.text!)!
            
        })

        
        self.tbvRecentSearch.reloadData()
    }
    

    

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchResults = self.recentSearches.filter({ (res: ClubEvent) -> Bool in
            
            // if time fileds are not set, results will not take time fields into account
            if textStartTime.text == "00:00" && textEndTime.text == "00:00" {
                return res.name?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil &&
                    dateFormatter.date(from: res.startDate!)! >= dateFormatter.date(from: textStartDate.text!)! &&
                    dateFormatter.date(from: res.startDate!)! <= dateFormatter.date(from: textEndDate.text!)!
            }
            return res.name?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil &&
                dateFormatter.date(from: res.startDate!)! >= dateFormatter.date(from: textStartDate.text!)! &&
                dateFormatter.date(from: res.startDate!)! <= dateFormatter.date(from: textEndDate.text!)! &&
                timeFormatter.date(from: res.startTime!)! >= timeFormatter.date(from: textStartTime.text!)! &&
                timeFormatter.date(from: res.startTime!)! <= timeFormatter.date(from: textEndTime.text!)!
            
        })
        
        
        self.tbvRecentSearch.reloadData()
        
        searchBar.endEditing(true)
    }
    



}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != "" {
            return searchResults.count
        }
        
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! ClubEventSmallCell
        
        
        let clubEvent: ClubEvent
        
        if searchBar.text != "" {
            
            clubEvent = searchResults[indexPath.row]
        }
        else {
            clubEvent = recentSearches[indexPath.row]
            
        }
        
        cell.lbSchool.text = clubEvent.schoolName ?? "神秘學校"
        cell.lbClub.text = clubEvent.clubName ?? "神秘社團"
        cell.lbEvent.text = clubEvent.name!
        cell.lbTime.text = clubEvent.startTime!
        if let startDate = clubEvent.startDate {
            let day = String(startDate.characters.suffix(2))
            cell.imgDate.image = UIImage(named: day)
        }
        if clubEvent.isCollected {
            cell.btnFavorite.setImage(#imageLiteral(resourceName: "favorite-on"), for: .normal)
        }
        else {
            cell.btnFavorite.setImage(#imageLiteral(resourceName: "favorite-off"), for: .normal)
        }

        
        // Setup cell style
        cell.layer.cornerRadius = 3

        
        return cell
    }
    

}


extension SearchViewController: UITextFieldDelegate {
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
