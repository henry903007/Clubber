//
//  BoardRecommendVC.swift
//  ClubAnimal
//
//  Created by HenrySu on 4/11/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit
import SwiftyJSON

class BoardRecommendVC: UITableViewController {

    private let reuseIdentifier = "ClubEventBigCell"

    let loadingView = LoadingIndicator()
    let dateFormatter = DateFormatter()

    var clubEvents = [ClubEvent]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup margin of the tableview
        tableView.contentInset = UIEdgeInsets(top: 10.5, left: 0, bottom: 10.5, right: 0)

        // Initialize the refresh control.
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.white
        self.refreshControl?.addTarget(self, action: #selector(BoardRecommendVC.refreshData), for: .valueChanged)
        let attributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
        let updateString = "Pull to refresh"
        
        self.refreshControl?.attributedTitle = NSAttributedString(string: updateString, attributes: attributes)
        
        
        loadClubEvents(showLoading: true)

    }

    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    
    func refreshData() {
        loadClubEvents(showLoading: false)
        
        if (self.refreshControl?.isRefreshing)! {
            
            self.refreshControl?.endRefreshing()
            
            DispatchQueue.main.async {
                let attributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
                
                self.dateFormatter.dateFormat = "MM/dd HH:mm"
                let updateString = "Last updated at \(self.dateFormatter.string(from: Date()))"
                
                
                self.refreshControl?.attributedTitle = NSAttributedString(string: updateString, attributes: attributes)
                
            }
            
        }
    }
    
    
    func loadClubEvents(showLoading: Bool) {
        
        if showLoading {
            loadingView.showLoading(in: self.tableView, color: UIColor.white)
        }
        
        
        APIManager.shared.getClubEvents { (json) in
            if json != nil {
                self.clubEvents = []
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
                            self.clubEvents.append(clubEvent)
                        }
                        self.tableView?.reloadData()
                    }
                    if showLoading {
                        self.loadingView.hideLoading()
                    }
                    
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
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubEvents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ClubEventBigCell

        let clubEvent: ClubEvent
        
        clubEvent = clubEvents[indexPath.row]
        
        cell.lbSchool.text = clubEvent.schoolName ?? "神秘學校"
        cell.lbClub.text = clubEvent.clubName ?? "神秘社團"
        cell.lbEvent.text = clubEvent.name!
        cell.lbLocation.text = clubEvent.location
        cell.lbTime.text = "\(clubEvent.startDate!.replacingOccurrences(of: " / ", with: ".")) - \(clubEvent.endDate!.replacingOccurrences(of: " / ", with: ".")) / \(clubEvent.startTime!) - \(clubEvent.endTime!)"
        Utils.loadImageFromURL(imageView: cell.imgThumbnail, urlString: clubEvent.imageURL!)
        if clubEvent.isCollected {
            cell.btnFavorite.setImage(#imageLiteral(resourceName: "favorite-on"), for: .normal)
        }
        else {
            cell.btnFavorite.setImage(#imageLiteral(resourceName: "favorite-off"), for: .normal)
        }
        
        cell.favButtonDidClick = {
            if clubEvent.isCollected {
                cell.btnFavorite.setImage(#imageLiteral(resourceName: "favorite-off"), for: .normal)
                clubEvent.setCollected(false)
                APIManager.shared.deleteFavoiteEvent(userId: User.currentUser.objectId!, eventId: clubEvent.objectId!, completionHandler: {})
            }
            else {
                cell.btnFavorite.setImage(#imageLiteral(resourceName: "favorite-on"), for: .normal)
                clubEvent.setCollected(true)

                APIManager.shared.addFavoiteEvent(userId: User.currentUser.objectId!, eventId: clubEvent.objectId!, completionHandler: {})
            }
        }
        
        // Setup cell style
        cell.layer.cornerRadius = 3
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as? EventDetailVC {
            
            vc.eventId = clubEvents[indexPath.row].objectId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
