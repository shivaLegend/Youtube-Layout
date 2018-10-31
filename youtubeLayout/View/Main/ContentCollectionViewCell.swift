//
//  ContentCollectionViewCell.swift
//  youtubeLayout
//
//  Created by Nguyen Duc Tai on 10/31/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameUserLbl: UILabel!
    @IBOutlet weak var describeLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let height = UIScreen.main.bounds.width*314/414
        dotView.layer.cornerRadius = 10
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.frame.height/2
        
        let percent = height/314
        describeLbl.font = describeLbl.font.withSize(percent*17)
        nameUserLbl.font = describeLbl.font.withSize(percent*13)
        timeLbl.font = describeLbl.font.withSize(percent*13)
    }

}
