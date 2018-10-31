//
//  ViewController.swift
//  youtubeLayout
//
//  Created by Nguyen Duc Tai on 10/31/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var actionBarTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        contentCollectionView.register(UINib.init(nibName: "ContentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ContentCollectionViewCell")
    }


}

extension ViewController: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        
        
        
        
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        actionBarTopConstraint.constant = -scrollView.contentOffset.y
//        print(actionBarTopConstraint.constant)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            actionBarTopConstraint.constant = -49
        } else if velocity.y < 0 {
            actionBarTopConstraint.constant = 0
            print("??")
            
        }
        print(velocity.y)
    }
    
}


