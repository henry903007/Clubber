//
//  ClubDetailVC.swift
//  Clubber
//
//  Created by HenrySu on 4/26/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit
import SwiftyJSON

class ClubDetailVC: UIViewController {
    
    var clubId: String?
    var club: Club!
    var clubEvents = [ClubEvent]()

    let loadingView = LoadingIndicator()
    
    fileprivate let reuseIdentifier = "ClubEventSmallCell"

    
    @IBOutlet weak var lbSchool: UILabel!
    @IBOutlet weak var lbClub: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    
    @IBOutlet weak var imgThumbnail: UIImageView!
    
    @IBOutlet weak var lbDescription: UITextView!
    
    @IBOutlet weak var lbContactInfo: UILabel!
    
    @IBOutlet weak var loadingBg: UIView!
    
    @IBOutlet weak var tbvClubEvents: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup margin of the tableview
        tbvClubEvents.contentInset = UIEdgeInsets(top: 7, left: 0, bottom: 17, right: 0)
        
        if clubId != nil {
            loadClubData(id: self.clubId!, showLoading: true)
            
        }
        
    }
    
    
    
    
    func loadClubData(id clubId: String, showLoading: Bool) {
        if showLoading {
            loadingBg.backgroundColor = UIColor.white
            self.showHideViewWithAnim(view: self.loadingBg, hidden: false)
            loadingView.showLoading(in: self.view, color: UIColor.black)
        }
        APIManager.shared.getClubData(byClubId: clubId) { (clubJson) in
            
            let queue = DispatchQueue(label: "clubber.henrysu.loadingClubQueue")
            
            queue.sync {
                if clubJson["error"] == nil {
                    let club = Club(json: clubJson)
                    self.club = club
                    
                    self.lbSchool.text = club.schoolName ?? "神秘學校"
                    self.lbClub.text = club.name
                    self.lbContactInfo.text = club.contactInfo
                    self.lbDescription.text = club.description
                    self.lbCategory.text = club.categoryName ?? "神秘類型"
                    Utils.loadImageFromURL(imageView: self.imgThumbnail, urlString: "https://farm9.staticflickr.com/8670/16050358412_7f6fd9c647.jpg")
                    self.clubEvents = []
                    if let listClubEvents = clubJson["events"].array {
                        
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
                        self.tbvClubEvents.reloadData()
                        }
                        
                    }

                    
                    self.title = club.name
                }
            }
            if showLoading {
                self.loadingView.hideLoading()
                self.showHideViewWithAnim(view: self.loadingBg, hidden: true)
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
    
    
    func showHideViewWithAnim(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: { _ in
            view.isHidden = hidden
        }, completion: nil)
    }
    
}

extension ClubDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ClubEventSmallCell
        
        
        let clubEvent: ClubEvent
        
        clubEvent = self.clubEvents[indexPath.row]
        
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
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as? EventDetailVC {
            
            vc.eventId = clubEvents[indexPath.row].objectId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
