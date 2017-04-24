//
//  ClubEventSmallCell.swift
//  ClubAnimal
//
//  Created by HenrySu on 4/13/17.
//  Copyright © 2017 Henry Su. All rights reserved.
//

import UIKit

class ClubEventSmallCell: UITableViewCell {

    @IBOutlet weak var lbSchool: UILabel!
    
    @IBOutlet weak var lbClub: UILabel!
    @IBOutlet weak var lbEvent: UILabel!
    
    @IBOutlet weak var lbTime: UILabel!
    
    @IBOutlet weak var imgDate: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Setup left and right margins
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            let widthInset: CGFloat = 18
            let heightInset: CGFloat = 5
            var frame = newFrame
            frame.origin.x += widthInset
            frame.size.width -= 2 * widthInset
            frame.origin.y += heightInset
            frame.size.height -= 2 * heightInset

            super.frame = frame
        }
    }
    


}
