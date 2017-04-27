//
//  SetupPreferenceVC.swift
//  Clubber
//
//  Created by HenrySu on 4/27/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

class SetupPreferenceVC: UIViewController {

    fileprivate let reuseIdentifier = "ClubCategoryCell"
    
    var clubCategories = [ClubCategory]()
    
    let activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "選擇喜好"

        loadClubTypes()
    }



    func loadClubTypes() {
        
        let loadingView = LoadingIndicator()
        loadingView.showLoading(in: collectionView!, color: UIColor(red:0.21, green:0.58, blue:0.72, alpha:1.0))
        
        APIManager.shared.getClubCategories { (json) in
            if json != nil {
                self.clubCategories = []
                
                if let listClubCategories = json["results"].array {
                    for item in listClubCategories {
                        let clubCategory = ClubCategory(json: item)
                        self.clubCategories.append(clubCategory)
                    }
                    
                    self.collectionView?.reloadData()
                    loadingView.hideLoading()
                }
            }
        }
    }

}

extension SetupPreferenceVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.clubCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ClubCategoryCell
        
        let clubCategory: ClubCategory
        
        clubCategory = clubCategories[indexPath.row]
        
        cell.lbClubCategoryName.text = clubCategory.name!
        
        return cell
    }
    
    
    
    
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ClubCategoryCell
        
        let clubCategory = clubCategories[indexPath.row]
        
        if clubCategory.isSelected {
            cell.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
            cell.lbClubCategoryName.textColor = UIColor(red:0.44, green:0.44, blue:0.44, alpha:1.0)
            clubCategories[indexPath.row].setIsSelected(false)
        }
        else {
            cell.backgroundColor = UIColor(red:0.21, green:0.58, blue:0.72, alpha:1.0)
            cell.lbClubCategoryName.textColor = UIColor.white
            clubCategories[indexPath.row].setIsSelected(true)

        }
    }
    
  
    
    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //            let picDimension = self.view.frame.size.width / 3.0
            return CGSize(width: 100, height: 50)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //        let leftRightInset = self.view.frame.size.width / 12.0
        return UIEdgeInsetsMake(0, 18, 0, 18)
    }

    
}
