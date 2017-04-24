//
//  BoardRecommendVC.swift
//  ClubAnimal
//
//  Created by HenrySu on 4/11/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

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
        
        
        loadClubEvents()

    }

    
    
    func refreshData() {
        loadClubEvents()
        
        if (self.refreshControl?.isRefreshing)! {
            
            self.refreshControl?.endRefreshing()
            
            DispatchQueue.main.async {
                let attributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
                
                self.dateFormatter.dateFormat = "MM/dd HH:mm"
                let updateString = "Last Updated at \(self.dateFormatter.string(from: Date()))"
                
                
                self.refreshControl?.attributedTitle = NSAttributedString(string: updateString, attributes: attributes)
                
            }
            
        }
    }
    
    
    func loadClubEvents() {
        
        if !(self.refreshControl?.isRefreshing)! {
            loadingView.showLoading(in: self.tableView)
        }
        
        
        APIManager.shared.getClubEvents { (json) in
            if json != nil {
                self.clubEvents = []
                if let listClubEvents = json["results"].array {
                    
                    if listClubEvents.count != 0 {
                        for item in listClubEvents {
                            let clubEvent = ClubEvent(json: item)
                            self.clubEvents.append(clubEvent)
                        }
                        self.tableView?.reloadData()
                    }
                    if !(self.refreshControl?.isRefreshing)! {
                        self.loadingView.hideLoading()
                    }
                    
                }
            }
        }
    }
    
    
    

        


    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return clubEvents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ClubEventBigCell

        let clubEvent: ClubEvent
        
        //indexPath.section is used rather than indexPath.row
        clubEvent = clubEvents[indexPath.row]
        
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
    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
