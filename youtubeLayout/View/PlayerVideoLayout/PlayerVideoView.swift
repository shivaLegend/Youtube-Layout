//
//  PlayerVideoView.swift
//  youtubeLayout
//
//  Created by Nguyen Duc Tai on 11/1/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit

class PlayerVideoView: UIView {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    
    var firstPosition: CGFloat!
    var heightOrigin: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let viewTemp: UIView = Bundle.main.loadNibNamed("PlayerVideoView", owner: self)?[0] as! UIView
        viewTemp.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(viewTemp)
        
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        
        heightOrigin = UIScreen.main.bounds.height
    }
    
    func show() {
        self.frame = UIScreen.main.bounds
        self.isHidden = false
        self.frame.origin.y = self.frame.height
        self.goFull()
        
    }
    
    func hide() {
        
    }
    
    func goFull() {
        
        self.topViewHeightConstraint.constant = 235
//        delegate?.videoView(self, animation: .Full, duration: 0.18, dest: CGPoint.init(x: 0, y: 0))
        UIView.animate(withDuration: 0.18) {
            self.bottomView.alpha = 1
            self.frame.origin.y = 0
            self.layoutIfNeeded()
            
        }
        
    }
    
    func goMini() {
        self.topViewHeightConstraint.constant = 54
//        delegate?.videoView(self, animation: .Mini, duration: 0.18, dest: CGPoint.init(x: 0, y: getMaxY()))
        UIView.animate(withDuration: 0.18) {
            self.bottomView.alpha = 0
            self.frame.origin.y = self.getMaxY()
            self.layoutIfNeeded()
            
        }
        
    }
    
    @IBAction func press_Pan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            firstPosition = self.frame.origin.y
            break
        case .changed:
            let offset = sender.translation(in: self.superview)
            let y  = offset.y + firstPosition
            self.frame.origin.y = y
            let maxY = getMaxY()
            let t = y/maxY
            topViewHeightConstraint.constant = 235 - t*(235 - 54)
            bottomView.alpha = 1 - t*(1-0)
            
            break
        case .ended,.cancelled,.failed:
            let velocity = sender.velocity(in: self.superview)
            if abs(velocity.y) > 800 {
                if velocity.y > 0 {
                    goMini()
                } else {
                    goFull()
                }
            } else {
                let offset = sender.translation(in: self.superview)
                let y  = offset.y + firstPosition
                let maxY = getMaxY()
                if y < maxY/2 {
                    goFull()
                } else {
                    goMini()
                }
            }
            
            break
        default:
            break
        }
    }
    
    func getMaxY()-> CGFloat {
        return UIScreen.main.bounds.height - 49 - 54 - 8
    }
}


