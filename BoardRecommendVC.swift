//
//  BoardRecommendVC.swift
//  ClubAnimal
//
//  Created by HenrySu on 4/11/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

class BoardRecommendVC: UITableViewController {

    private let reuseIdentifier = "ClubEventCell"

    var clubEvents = [ClubEvent]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 3, left: 0, bottom: 18, right: 0)
        
        loadClubEvents()

    }

    
    func loadClubEvents() {
        let loadingView = LoadingIndicator()
        loadingView.showLoading(in: tableView)
        
        APIManager.shared.getClubEvents { (json) in
            if json != nil {
                self.clubEvents = []
                if let listClubEvents = json["results"].array {
                    for item in listClubEvents {
                        print(item)
                        let clubEvent = ClubEvent(json: item)
                        self.clubEvents.append(clubEvent)
                    }
                    self.tableView?.reloadData()
                    loadingView.hideLoading()
                }
            }
        }
    }
    


    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return clubEvents.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ClubEventCell

        let clubEvent: ClubEvent
        
        //indexPath.section is used rather than indexPath.row
        clubEvent = clubEvents[indexPath.section]
        
//        cell.lbSchool.text
//        cell.lbClub.text
        cell.lbEvent.text = clubEvent.name!
        cell.lbLocation.text = clubEvent.location
        cell.lbTime.text = "\(clubEvent.startDate!) - \(clubEvent.endDate!) / \(clubEvent.startTime!) - \(clubEvent.endTime!)"
        Utils.loadImageFromURL(imageView: cell.imgThumbnail, urlString: clubEvent.imageURL!)
        
        // Setup cell style
        cell.layer.cornerRadius = 3
        
        return cell
    }
    
    // Setup spacing between cells
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
 
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v: UIView = UIView()
        v.backgroundColor = UIColor.clear
        return v
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
