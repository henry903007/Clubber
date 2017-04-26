//
//  FavoriteVC.swift
//  Clubber
//
//  Created by HenrySu on 4/24/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

class FavoriteVC: UIViewController {

    fileprivate let reuseIdentifierBig = "ClubEventBigCell"
    fileprivate let reuseIdentifierSmall = "ClubEventSmallCell"

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tbvFavoriteEvents: UITableView!
    let loadingView = LoadingIndicator()
    
    var favoriteEvents = [String: [ClubEvent]]() // "2017, 4" : []
    var filteredFavoriteEvents = [String: [ClubEvent]]()
    var eventSectionTitle = [String]()
    var filteredEventSectionTitle = [String]()
    var isBigCellLayout = true


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收藏"
        hideKeyboardWhenTappedAround()

        
        // Setup margin of the tableview
        tbvFavoriteEvents.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 7.5, right: 0)
        
        searchBar.backgroundImage = UIImage()

        loadUserFavoriteEvents(showLoading: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteEvents = [:]
        eventSectionTitle = []
        filteredFavoriteEvents = [:]
        filteredEventSectionTitle = []

        loadUserFavoriteEvents(showLoading: false)
    }
    
    
    
    @IBAction func layoutSwitchDidClick(_ sender: UIBarButtonItem) {
        
        if isBigCellLayout {
            isBigCellLayout = false
            sender.image = UIImage(named: "layout-big-cell")
            
            
        }
        else {
            isBigCellLayout = true
            sender.image = UIImage(named: "layout-small-cell")
            
        }
        
        self.view.endEditing(true)
        tbvFavoriteEvents.reloadData()
        
    }
    
    
    func loadUserFavoriteEvents(showLoading: Bool) {
        if showLoading {
            loadingView.showLoading(in: self.tbvFavoriteEvents, color: UIColor.white)
        }
        APIManager.shared.getUserData { (json) in
            if json != nil {
                self.favoriteEvents = [:]
                self.eventSectionTitle = []
                self.filteredFavoriteEvents = [:]
                self.filteredEventSectionTitle = []
                
                if let listClubEvents = json["events"].array {
                    
                    for event in listClubEvents {
                        
                        if let monthSection = event["time"].string {
                            
                            let clubEvent = ClubEvent(json: event)
                            
                            
                            if self.favoriteEvents[monthSection] == nil {
                                self.eventSectionTitle.append(monthSection)
                                self.favoriteEvents[monthSection] = []
                            }
                            self.favoriteEvents[monthSection]?.append(clubEvent)
                        }
                        
                    }
                    
                        self.tbvFavoriteEvents.reloadData()

                    
                    if showLoading {
                        self.loadingView.hideLoading()
                    }
                }
            }
        }
    }
    
    
    
}


extension FavoriteVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(self.favoriteEvents)
        print(self.eventSectionTitle)
        print(self.filteredFavoriteEvents)
        print(self.filteredEventSectionTitle)
        

        filteredFavoriteEvents = [:]
        filteredEventSectionTitle = []
        
        for section in eventSectionTitle {
            let filteredResult = favoriteEvents[section]?.filter({ (res: ClubEvent) -> Bool in
                
                return res.name?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil ||
                    res.schoolName?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil ||
                    res.clubName?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil
            })
            
            if (filteredResult?.count)! > 0 {
                filteredEventSectionTitle.append(section)
                filteredFavoriteEvents[section] = filteredResult
            }

        }

        print(self.favoriteEvents)
        print(self.eventSectionTitle)
        print(self.filteredFavoriteEvents)
        print(self.filteredEventSectionTitle)
        

        self.tbvFavoriteEvents.reloadData()
    }
    
    
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        filteredFavoriteEvents = [:]
        filteredEventSectionTitle = []

        for section in eventSectionTitle {
            let filteredResult = favoriteEvents[section]?.filter({ (res: ClubEvent) -> Bool in
                
                return res.name?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil ||
                    res.schoolName?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil ||
                    res.clubName?.lowercased().range(of: (searchBar.text?.lowercased())!) != nil
            })
            
            if (filteredResult?.count)! > 0 {
                filteredEventSectionTitle.append(section)
                filteredFavoriteEvents[section] = filteredResult
            }
        }

        tbvFavoriteEvents.reloadData()
        
        searchBar.endEditing(true)
    }

    

}


extension FavoriteVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchBar.text != "" {
            return filteredFavoriteEvents.count
        }
        
        return favoriteEvents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != "" {
            return filteredFavoriteEvents[filteredEventSectionTitle[section]]!.count
        }
        
        return favoriteEvents[eventSectionTitle[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        let clubEvent: ClubEvent
        
        if searchBar.text != "" {
            clubEvent = (filteredFavoriteEvents[filteredEventSectionTitle[indexPath.section]]?[indexPath.row])!

        }
        else {
            // get section then get event in that section
            clubEvent = (favoriteEvents[eventSectionTitle[indexPath.section]]?[indexPath.row])!
        }

        
        if isBigCellLayout {
            let bigCell: ClubEventBigCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierBig, for: indexPath) as! ClubEventBigCell
            
            bigCell.lbSchool.text = clubEvent.schoolName ?? "神秘學校"
            bigCell.lbClub.text = clubEvent.clubName ?? "神秘社團"
            bigCell.lbEvent.text = clubEvent.name!
            bigCell.lbLocation.text = clubEvent.location
            bigCell.lbTime.text = "\(clubEvent.startDate!) - \(clubEvent.endDate!) / \(clubEvent.startTime!) - \(clubEvent.endTime!)"
            Utils.loadImageFromURL(imageView: bigCell.imgThumbnail, urlString: clubEvent.imageURL!)
            bigCell.btnFavorite.setImage(#imageLiteral(resourceName: "favorite-on"), for: .normal)
            bigCell.favButtonDidClick = {
                
                // update dataset in display
                if self.searchBar.text != "" {
                    let currentTitle = self.filteredEventSectionTitle[indexPath.section]
                    
                    self.filteredFavoriteEvents[currentTitle]?.remove(at: indexPath.row)
                    self.favoriteEvents[currentTitle]?.remove(at: indexPath.row)
                    
                    if self.favoriteEvents[currentTitle]?.count == 0 {
                        self.favoriteEvents.removeValue(forKey: currentTitle)
                        self.eventSectionTitle.remove(at: self.eventSectionTitle.index(of: currentTitle)! )
                    }
                    
                    if self.filteredFavoriteEvents[currentTitle]?.count == 0 {
                        self.filteredFavoriteEvents.removeValue(forKey: currentTitle)
                        self.filteredEventSectionTitle.remove(at: indexPath.section)
                    }
                }
                else {
                    let currentTitle = self.eventSectionTitle[indexPath.section]

                    self.favoriteEvents[currentTitle]?.remove(at: indexPath.row)
                    if self.favoriteEvents[currentTitle]?.count == 0 {
                        self.favoriteEvents.removeValue(forKey: currentTitle)
                        self.eventSectionTitle.remove(at: indexPath.section)
                    }
                }
                
                
                tableView.reloadData()
                
                APIManager.shared.deleteFavoiteEvent(userId: User.currentUser.objectId!, eventId: clubEvent.objectId!, completionHandler: {}
                )
            }

            
            cell = bigCell
        }
        else {
            let smallCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierSmall, for: indexPath) as! ClubEventSmallCell
        
            smallCell.lbSchool.text = clubEvent.schoolName ?? "神秘學校"
            smallCell.lbClub.text = clubEvent.clubName ?? "神秘社團"
            smallCell.lbEvent.text = clubEvent.name!
            smallCell.lbTime.text = clubEvent.startTime!
            if let startDate = clubEvent.startDate {
                let day = String(startDate.characters.suffix(2))
                smallCell.imgDate.image = UIImage(named: day)
            }
            smallCell.btnFavorite.setImage(#imageLiteral(resourceName: "favorite-on"), for: .normal)
            smallCell.favButtonDidClick = {

                // update dataset in display
                if self.searchBar.text != "" {
                    let currentTitle = self.filteredEventSectionTitle[indexPath.section]
                    
                    self.filteredFavoriteEvents[currentTitle]?.remove(at: indexPath.row)
                    self.favoriteEvents[currentTitle]?.remove(at: indexPath.row)
                    
                    if self.favoriteEvents[currentTitle]?.count == 0 {
                        self.favoriteEvents.removeValue(forKey: currentTitle)
                        self.eventSectionTitle.remove(at: self.eventSectionTitle.index(of: currentTitle)! )
                    }
                    
                    if self.filteredFavoriteEvents[currentTitle]?.count == 0 {
                        self.filteredFavoriteEvents.removeValue(forKey: currentTitle)
                        self.filteredEventSectionTitle.remove(at: indexPath.section)
                    }
                }
                else {
                    let currentTitle = self.eventSectionTitle[indexPath.section]
                    
                    self.favoriteEvents[currentTitle]?.remove(at: indexPath.row)
                    if self.favoriteEvents[currentTitle]?.count == 0 {
                        self.favoriteEvents.removeValue(forKey: currentTitle)
                        self.eventSectionTitle.remove(at: indexPath.section)
                    }
                }
                
                tableView.reloadData()
                
                APIManager.shared.deleteFavoiteEvent(userId: User.currentUser.objectId!, eventId: clubEvent.objectId!, completionHandler: {})
            }
            
            cell = smallCell
        }

        
        // Setup cell style
        cell.layer.cornerRadius = 3
        
        return cell
    }
    
    // TODO: Select cell while refreshing will cause indexpath out ou range erroe
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as? EventDetailVC {

            let clubEvent: ClubEvent
            
            if searchBar.text != "" {
                clubEvent = (filteredFavoriteEvents[filteredEventSectionTitle[indexPath.section]]?[indexPath.row])!
            }
            else {
                // get section then get event in that section
                clubEvent = (favoriteEvents[eventSectionTitle[indexPath.section]]?[indexPath.row])!
            }

            
            vc.eventId = clubEvent.objectId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isBigCellLayout {
            return 265
        }
        else {
            return 74
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "DateHeaderCell") as! DateHeader
        let sectionTitle: [String]
        
        if searchBar.text != "" {
            // [yyyy, mm]
             sectionTitle = filteredEventSectionTitle[section].components(separatedBy: ",")
        }
        else {
            sectionTitle = eventSectionTitle[section].components(separatedBy: ",")
        }


        headerCell.lbTitle.text = "\(sectionTitle[0]) 年  \(sectionTitle[1]) 月"
        
        return headerCell
    }
    
}

