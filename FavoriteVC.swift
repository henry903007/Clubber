//
//  FavoriteVC.swift
//  Clubber
//
//  Created by HenrySu on 4/24/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

class FavoriteVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tbvFavoriteEvents: UITableView!
    
    fileprivate let reuseIdentifierBig = "ClubEventBigCell"
    fileprivate let reuseIdentifierSmall = "ClubEventSmallCell"

    var favoriteEvents = [String: [ClubEvent]]() // "2017, 4" : []
    var eventDateSections = [String]()
    
    var isBigCellLayout = true
    
    let loadingView = LoadingIndicator()



    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "收藏"
        
        // Setup margin of the tableview
        tbvFavoriteEvents.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 7.5, right: 0)
        
        searchBar.backgroundImage = UIImage()

        loadUserFavoriteEvents(showLoading: true)
        
        self.hideKeyboardWhenTappedAround()


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
            
        // update layout first
        // if there are new data, it will be shown next switching 
        tbvFavoriteEvents.reloadData()
        loadUserFavoriteEvents(showLoading: false)
      
    }
    

    func loadUserFavoriteEvents(showLoading: Bool) {
        if showLoading {
            loadingView.showLoading(in: self.tbvFavoriteEvents)
        }
        APIManager.shared.getUserData { (json) in
            if json != nil {
                self.favoriteEvents = [:]
                if let listClubEvents = json["events"].array {
                    
                    if listClubEvents.count != 0 {
                        for event in listClubEvents {
                            
                            if let monthSection = event["time"].string {
                                
                                let clubEvent = ClubEvent(json: event)
                                
                                if self.favoriteEvents[monthSection] == nil {
                                    self.eventDateSections.append(monthSection)
                                    self.favoriteEvents[monthSection] = []
                                }
                                self.favoriteEvents[monthSection]?.append(clubEvent)
                            }
                            
                        }
                        self.tbvFavoriteEvents.reloadData()
                    }
                    
                    if showLoading {
                        self.loadingView.hideLoading()
                    }
                }
            }
        }
        
        
    }
    
}


extension FavoriteVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return favoriteEvents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoriteEvents[eventDateSections[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        let clubEvent: ClubEvent
        
        // get section then get event in that section
        clubEvent = (favoriteEvents[eventDateSections[indexPath.section]]?[indexPath.row])!
        

        if isBigCellLayout {
            let bigCell: ClubEventBigCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierBig, for: indexPath) as! ClubEventBigCell
            
            bigCell.lbSchool.text = clubEvent.schoolName ?? "神秘學校"
            bigCell.lbClub.text = clubEvent.clubName ?? "神秘社團"
            bigCell.lbEvent.text = clubEvent.name!
            bigCell.lbLocation.text = clubEvent.location
            bigCell.lbTime.text = "\(clubEvent.startDate!) - \(clubEvent.endDate!) / \(clubEvent.startTime!) - \(clubEvent.endTime!)"
            Utils.loadImageFromURL(imageView: bigCell.imgThumbnail, urlString: clubEvent.imageURL!)
            
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
            
            cell = smallCell
        }

        
        // Setup cell style
        cell.layer.cornerRadius = 3
        
        return cell
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
        
        // [yyyy, mm]
        let sectionTitle = eventDateSections[section].components(separatedBy: ",")

        headerCell.lbTitle.text = "\(sectionTitle[0]) 年  \(sectionTitle[1]) 月"
        
        return headerCell
    }
    
}

