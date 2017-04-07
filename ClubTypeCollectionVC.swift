//
//  ClubTypeCollectionVC.swift
//  ClubAnimal
//
//  Created by HenrySu on 4/6/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit





class ClubTypeCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let reuseIdentifier = "ClubTypeCell"

    var clubTypes = [ClubType]()

    let activityIndicator = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadClubTypes()

    }
    
    func loadClubTypes() {
        
        showActivityIndicator()
        
        APIManager.shared.getClubTypes { (json) in
            if json != nil {
                print(json)
                self.clubTypes = []
                
                if let listClubTypes = json["results"].array {
                    for item in listClubTypes {
                        print(item)
                        let clubType = ClubType(json: item)
                        self.clubTypes.append(clubType)
                    }
                    
                    self.collectionView?.reloadData()
                    self.hideActivityIndicator()
                }
            }
        }
    }
    
    func showActivityIndicator() {
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        
        // view is default to the current view controller
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = UIColor.black
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.clubTypes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ClubTypeCell
        
        let clubType: ClubType
        
        clubType = clubTypes[indexPath.row]
        
        cell.lbClubTypeName.text = clubType.name!
    
        return cell
    }

    
    

    


    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: - UICollectionViewFlowLayout
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let picDimension = self.view.frame.size.width / 3.0
//        return CGSize(width: picDimension, height: picDimension)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let leftRightInset = self.view.frame.size.width / 12.0
        return UIEdgeInsetsMake(24, 18, 24, 18)
    }


}


