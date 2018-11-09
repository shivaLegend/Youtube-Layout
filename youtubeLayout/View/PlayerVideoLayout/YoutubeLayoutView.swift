//
//  PlayerVideoView.swift
//  youtubeLayout
//
//  Created by Nguyen Duc Tai on 11/1/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit


class YoutubeLayoutView: UIView {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var bottomView: UICollectionView!
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var detailMiniView: UIView!
    
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var videoViewWidthConstraint: NSLayoutConstraint!
    
    
    var firstPosition: CGFloat!
    var heightOrigin: CGFloat!
    var originTopViewHeight: CGFloat!
    var witdhOrigin: CGFloat!
    var delegate: YoutubeLayoutViewDelegate?
    var imageView: UIImageView!
    var heightMiniVideoView: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let viewTemp: UIView = Bundle.main.loadNibNamed("YoutubeLayoutView", owner: self)?[0] as! UIView
        viewTemp.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(viewTemp)
        
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        
        bottomView.register(UINib.init(nibName: "AdCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AdCollectionViewCell")
        
        bottomView.register(UINib.init(nibName: "TitleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TitleCollectionViewCell")
        
        bottomView.register(UINib.init(nibName: "SelectionBarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectionBarCollectionViewCell")
        
        bottomView.register(UINib.init(nibName: "SubscribeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SubscribeCollectionViewCell")
        
        bottomView.register(UINib.init(nibName: "AutoPlayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AutoPlayCollectionViewCell")
        
        bottomView.register(UINib.init(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionViewCell")
        
        bottomView.delegate = self
        bottomView.dataSource = self
        let image = UIImage(named: "view cell")
        imageView = UIImageView(image: image!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        videoView.addSubview(imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: videoView, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: videoView, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: videoView, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: videoView, attribute: .right, multiplier: 1, constant: 0))
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        heightOrigin = UIScreen.main.bounds.height
        witdhOrigin = UIScreen.main.bounds.width
        heightMiniVideoView = heightOrigin*55/736
        
        
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
            self.detailMiniView.alpha = 0
            self.layoutIfNeeded()
        }
        
//        imageView.frame = CGRect(x: 0, y: 0, width: videoView.frame.width, height: topViewHeightConstraint.constant)//tai sao set cha no ma con can phai set subvview ????
        
        delegate?.playerVideo(state: PlayerVideoState.Full)
        UIView.animate(withDuration: 0.18) {
            self.bottomView.alpha = 1
            self.frame.origin.y = 0
            self.layoutIfNeeded()
            
        }
        
    }
    
    func goMini() {
        self.topViewHeightConstraint.constant = heightMiniVideoView
        self.videoViewWidthConstraint.constant = heightMiniVideoView*16/9
        
        delegate?.playerVideo(state: PlayerVideoState.Mini)
        UIView.animate(withDuration: 0.18) {
            self.bottomView.alpha = 0
            self.detailMiniView.alpha = 1
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
            var y  = offset.y + firstPosition
            
            let maxY = getMaxY()
            y = max(0,y)
            y = min(maxY,y)
            self.frame.origin.y = y
            let t = y/maxY
            let offSetForTabbed = heightOrigin - t*(heightOrigin - (heightOrigin - 49))
            delegate?.playerVideo(offset: offSetForTabbed)
            topViewHeightConstraint.constant = originTopViewHeight - t*(originTopViewHeight - heightMiniVideoView)
            bottomView.alpha = 1 - t*(1-0)
            
            if topViewHeightConstraint.constant <= heightMiniVideoView*1.3{
                let tyle = (heightMiniVideoView*1.3 - topViewHeightConstraint.constant)/(heightMiniVideoView*1.3 - heightMiniVideoView)
                let width = witdhOrigin - tyle*(witdhOrigin - heightMiniVideoView*16/9)
                detailMiniView.alpha = 0 - (0 - 1)*tyle
                videoViewWidthConstraint.constant = width
            } else {
                detailMiniView.alpha = 0
                videoViewWidthConstraint.constant = witdhOrigin
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
        return UIScreen.main.bounds.height - 49 - heightMiniVideoView - 8
    }
}

extension YoutubeLayoutView: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdCollectionViewCell", for: indexPath)
            
            return cell
        } else if indexPath.row == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AutoPlayCollectionViewCell", for: indexPath)
            
            return cell
        } else if indexPath.row == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectionBarCollectionViewCell", for: indexPath)
            
            return cell
        } else if indexPath.row == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscribeCollectionViewCell", for: indexPath)
            
            return cell
        } else if indexPath.row == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath)
            
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*52/414)
        } else if indexPath.row == 1 {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*100/414)
        } else if indexPath.row == 2{
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*52/414)
        } else if indexPath.row == 3{
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*52/414)
        } else if indexPath.row == 4{
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*52/414)
        }
        
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*108/414)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        playerVideoView.show()
        
        
    }
}

