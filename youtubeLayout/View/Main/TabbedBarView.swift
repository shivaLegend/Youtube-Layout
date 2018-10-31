//
//  TabbedBarView.swift
//  youtubeLayout
//
//  Created by Nguyen Duc Tai on 10/31/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit

class TabbedBarView: UIView {
    var viewTemp: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewTemp = Bundle.main.loadNibNamed("TabbedBarView", owner: self)?[0] as? UIView
        viewTemp.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(viewTemp)
        
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
    }
    
    @IBAction func chooseStatusButton(_ sender: UIButton) {
        for view in viewTemp.subviews {
            changeColor(color: .black, target: view)
        }
        
        if let viewInSender = sender.superview {
            changeColor(color: .red, target: viewInSender)
        }
    }
    
    func changeColor(color: UIColor, target: UIView) {
        for child in target.subviews {
            if let temp = child as? UIImageView {
                temp.image = temp.image!.withRenderingMode(.alwaysTemplate)
                temp.tintColor = color
            } else if let temp = child as? UILabel {
                temp.textColor = color
            }
        }
    }
    
}
