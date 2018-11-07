//
//  YoutubeLayoutContentView.swift
//  youtubeLayout
//
//  Created by Nguyen Duc Tai on 11/7/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit

class YoutubeLayoutContentView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let viewTemp: UIView = Bundle.main.loadNibNamed("YoutubeLayoutContentView", owner: self)?[0] as! UIView
        viewTemp.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(viewTemp)
        
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: viewTemp, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
        
        
    }
}

extension YoutubeLayoutContentView: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as! ContentCollectionViewCell
        
        
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*314/414)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        playerVideoView.show()
        
        
    }
}
