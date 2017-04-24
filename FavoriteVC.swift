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
    
    
    let loadingView = LoadingIndicator()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "收藏"
        
        // Setup margin of the tableview
        tbvFavoriteEvents.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 7.5, right: 0)
        
        searchBar.backgroundImage = UIImage()

        
        loadUserFavoriteEvents()

    }


    
    func loadUserFavoriteEvents() {
        
        loadingView.showLoading(in: self.tbvFavoriteEvents)

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
                        print(self.eventDateSections)
                        print(self.favoriteEvents)

                        self.tbvFavoriteEvents.reloadData()
                    }
                    
                        self.loadingView.hideLoading()
                    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierBig, for: indexPath) as! ClubEventBigCell
        
        let clubEvent: ClubEvent
        
        // get section then get event in that section
        clubEvent = (favoriteEvents[eventDateSections[indexPath.section]]?[indexPath.row])!
        
        cell.lbSchool.text = clubEvent.schoolName ?? "神秘學校"
        cell.lbClub.text = clubEvent.clubName ?? "神秘社團"
        cell.lbEvent.text = clubEvent.name!
        cell.lbLocation.text = clubEvent.location
        cell.lbTime.text = "\(clubEvent.startDate!) - \(clubEvent.endDate!) / \(clubEvent.startTime!) - \(clubEvent.endTime!)"
        Utils.loadImageFromURL(imageView: cell.imgThumbnail, urlString: clubEvent.imageURL!)
        
        // Setup cell style
        cell.layer.cornerRadius = 3
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "DateHeaderCell") as! DateHeader
        
        // [yyyy, mm]
        let sectionTitle = eventDateSections[section].components(separatedBy: ",")

        headerCell.lbTitle.text = "\(sectionTitle[0]) 年  \(sectionTitle[1]) 月"
        
        return headerCell
    }
    
}
