//
//  EventDetailVC.swift
//  Clubber
//
//  Created by HenrySu on 4/26/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventDetailVC: UIViewController {

    var eventId: String?
    var clubEvent: ClubEvent!
    
    let loadingView = LoadingIndicator()

    @IBOutlet weak var lbSchool: UILabel!
    @IBOutlet weak var lbClub: UILabel!
    @IBOutlet weak var lbEvent: UILabel!
    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var lbDescription: UITextView!
    @IBOutlet weak var lbSignupLink: UILabel!
    
    @IBOutlet weak var btnFavorite: UIButton!
    
    
    @IBOutlet weak var loadingBg: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "clubDidClick")
        lbClub.addGestureRecognizer(gestureRecognizer)
    
        if eventId != nil {
            loadEventData(id: self.eventId!, showLoading: true)
            
        }

    }
    
    
    @IBAction func favBtnDidClick(_ sender: UIButton) {
        
            if self.clubEvent.isCollected {
                self.btnFavorite.setImage(#imageLiteral(resourceName: "favorite-off"), for: .normal)
                clubEvent.setCollected(false)
                APIManager.shared.deleteFavoiteEvent(userId: User.currentUser.objectId!, eventId: clubEvent.objectId!, completionHandler: {})
            }
            else {
                self.btnFavorite.setImage(#imageLiteral(resourceName: "favorite-on"), for: .normal)
                clubEvent.setCollected(true)
                
                APIManager.shared.addFavoiteEvent(userId: User.currentUser.objectId!, eventId: clubEvent.objectId!, completionHandler: {})
            }
     
    }

    
    func loadEventData(id eventId: String, showLoading: Bool) {
        if showLoading {
            loadingBg.backgroundColor = UIColor.white
            self.showHideViewWithAnim(view: self.loadingBg, hidden: false)
            loadingView.showLoading(in: self.view, color: UIColor.black)
        }
        APIManager.shared.getEventData(byEventId: eventId) { (eventJson) in
            
            let queue = DispatchQueue(label: "clubber.henrysu.loadingEventQueue")
            
            queue.sync {
                if eventJson["error"] == nil {
                    let clubEvent = ClubEvent(json: eventJson)
                    self.clubEvent = clubEvent

                    if let eventUsers = eventJson["users"].array {
                        if self.isCurrentUserInTheUserArray(userArray: eventUsers) {
                            clubEvent.setCollected(true)
                        }
                        else {
                            clubEvent.setCollected(false)
                        }
                    }

                    self.lbSchool.text = clubEvent.schoolName ?? "神秘學校"
                    self.lbClub.text = clubEvent.clubName ?? "神秘社團"
                    self.lbEvent.text = clubEvent.name
                    
                    self.lbLocation.text = clubEvent.location
                    self.lbDate.text = "\(clubEvent.startDate!.replacingOccurrences(of: " / ", with: ".")) - \(clubEvent.endDate!.replacingOccurrences(of: " / ", with: ".")) / \(clubEvent.startTime!) - \(clubEvent.endTime!)"
                    Utils.loadImageFromURL(imageView: self.imgThumbnail, urlString: clubEvent.imageURL!)
                    if clubEvent.isCollected {
                        self.btnFavorite.setImage(#imageLiteral(resourceName: "favorite-on"), for: .normal)
                    }
                    else {
                        self.btnFavorite.setImage(#imageLiteral(resourceName: "favorite-off"), for: .normal)
                    }
                    
                    self.title = clubEvent.name
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
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: { _ in
            view.isHidden = hidden
        }, completion: nil)
    }
    
    func clubDidClick() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ClubDetailVC") as? ClubDetailVC {
            
            vc.clubId = clubEvent.clubId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
