//
//  ActionBar.swift
//  youtubeLayout
//
//  Created by Nguyen Duc Tai on 10/31/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit

class ActionBarView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let viewTemp: UIView = Bundle.main.loadNibNamed("ActionBarView", owner: self)?[0] as! UIView
        viewTemp.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(viewTemp)
        
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        
        
    }
}
