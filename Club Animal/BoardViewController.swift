//
//  FirstViewController.swift
//  Club Animal
//
//  Created by HenrySu on 3/9/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class BoardViewController: UIViewController {

    enum TabIndex : Int {
        case boardRecommendTab = 0
        case boardCategoryTab = 1
    }
    
    @IBOutlet weak var segmentedControl: BoardSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    var currentViewController: UIViewController?
    
    lazy var boardRecommendVC: UIViewController? = {
        let boardRecommendVC = self.storyboard?.instantiateViewController(withIdentifier: "boardRecommendVC")
        return boardRecommendVC
    }()
    lazy var boardCategoryVC : UIViewController? = {
        let boardCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "boardCategoryVC")
        return boardCategoryVC
    }()
    
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "看板"
        self.automaticallyAdjustsScrollViewInsets = false
        
        segmentedControl.initUI()
        segmentedControl.selectedSegmentIndex = TabIndex.boardRecommendTab.rawValue
        displayCurrentTab(TabIndex.boardRecommendTab.rawValue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    
    // MARK: - Switching Tabs Functions
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            
            vc.view.frame = self.containerView.bounds
            self.containerView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.boardRecommendTab.rawValue :
            vc = boardRecommendVC
        case TabIndex.boardCategoryTab.rawValue :
            vc = boardCategoryVC
        default:
            return nil
        }
        
        return vc
    }

}


