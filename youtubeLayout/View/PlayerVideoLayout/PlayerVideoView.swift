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
    @IBOutlet weak var closeImageView: UIImageView!
    
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var videoViewWidthConstraint: NSLayoutConstraint!
    
    
    var firstPosition: CGFloat!
    var heightOrigin: CGFloat!
    var originTopViewHeight: CGFloat!
    var witdhOrigin: CGFloat!
    var delegate: PlayerVideoViewDelegate?
    var imageView: UIImageView!
    var limitHeightVideoView: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bottomView.register(UINib.init(nibName: "AdCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AdCollectionViewCell")

      bottomView.register(UINib.init(nibName: "TitleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TitleCollectionViewCell")

      bottomView.register(UINib.init(nibName: "SelectionBarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectionBarCollectionViewCell")

      bottomView.register(UINib.init(nibName: "SubscribeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SubscribeCollectionViewCell")

      bottomView.register(UINib.init(nibName: "AutoPlayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AutoPlayCollectionViewCell")
      
      bottomView.register(UINib.init(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionViewCell")
        let viewTemp: UIView = Bundle.main.loadNibNamed("PlayerVideoView", owner: self)?[0] as! UIView
        viewTemp.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(viewTemp)
        
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        
        videoView.frame = CGRect(x: 0, y: 0, width: topView.frame.width, height: topView.frame.height)
        
        let image = UIImage(named: "view cell")
        imageView = UIImageView(image: image!)
        videoView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: videoView.frame.width, height: videoView.frame.height)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        heightOrigin = UIScreen.main.bounds.height
        witdhOrigin = UIScreen.main.bounds.width
        limitHeightVideoView = 9*witdhOrigin/(16*3)
        
        print(limitHeightVideoView)
        //Set for video 16:9
        videoViewWidthConstraint.constant = witdhOrigin
        topViewHeightConstraint.constant = 9*witdhOrigin/16
        
        originTopViewHeight = 9*witdhOrigin/16
        //add action for close uiimageview
        let tapClose = UITapGestureRecognizer(target: self, action: #selector(hide))
        closeImageView.addGestureRecognizer(tapClose)
        closeImageView.isUserInteractionEnabled = true
    }
    
    func show() {
        self.frame = UIScreen.main.bounds
        self.isHidden = false
        self.frame.origin.y = self.frame.height
        self.goFull()
        
    }
    
    @objc func hide() {
        self.frame = UIScreen.main.bounds
        self.isHidden = true
        self.frame.origin.y = self.frame.height
        
    }
    
    func goFull() {
        self.topViewHeightConstraint.constant = originTopViewHeight
        videoViewWidthConstraint.constant = witdhOrigin
        UIView.animate(withDuration: 0.18) {
            self.layoutIfNeeded()
        }
        
        imageView.frame = CGRect(x: 0, y: 0, width: videoView.frame.width, height: topViewHeightConstraint.constant)//tai sao set cha no ma con can phai set subvview ????
        
        delegate?.playerVideo(state: PlayerVideoState.Full)
        UIView.animate(withDuration: 0.18) {
            self.bottomView.alpha = 1
            self.frame.origin.y = 0
            self.layoutIfNeeded()
            
        }
        
    }
    
    func goMini() {
        self.topViewHeightConstraint.constant = 54
        
        //why not animate video width
        self.videoViewWidthConstraint.constant = self.witdhOrigin/3
        print(self.witdhOrigin/3)
        UIView.animate(withDuration: 0.18) {
            self.layoutIfNeeded()
        }
//        closeView.isHidden = false
        
        delegate?.playerVideo(state: PlayerVideoState.Mini)
        
        imageView.frame = CGRect(x: 0, y: 0, width: videoView.frame.width, height: topViewHeightConstraint.constant)
        UIView.animate(withDuration: 0.18) {
            self.bottomView.alpha = 0
            self.frame.origin.y = self.getMaxY()
            self.layoutIfNeeded()
            self.videoView.layoutIfNeeded()
            
        }
        
    }
    
    @IBAction func press_Pan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            firstPosition = self.frame.origin.y
            break
        case .changed:
            let offset = sender.translation(in: self.superview)
            var y  = offset.y + firstPosition
            
            let maxY = getMaxY()
            y = max(0,y)
            y = min(maxY,y)
            self.frame.origin.y = y
            let t = y/maxY
            let offSetForTabbed = heightOrigin - t*(heightOrigin - (heightOrigin - 49))
            delegate?.playerVideo(offset: offSetForTabbed)
            topViewHeightConstraint.constant = originTopViewHeight - t*(originTopViewHeight - 54)
            imageView.frame = CGRect(x: 0, y: 0, width: videoView.frame.width, height: topViewHeightConstraint.constant)
            bottomView.alpha = 1 - t*(1-0)
            
            if topViewHeightConstraint.constant <= 73 {
                let tyle = (73 - topViewHeightConstraint.constant)/(73 - 54)
                let width = witdhOrigin - tyle*(witdhOrigin - witdhOrigin/3)
                videoViewWidthConstraint.constant = width
            }
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


