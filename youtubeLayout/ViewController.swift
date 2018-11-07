//
//  ViewController.swift
//  youtubeLayout
//
//  Created by Nguyen Duc Tai on 10/31/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    @IBOutlet weak var actionBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var actionBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerVideoView: PlayerVideoView!
    @IBOutlet weak var tabbedBarView: TabbedBarView!
    
    
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    var heightActionBar: CGFloat!
    var check: Bool = false
    var firstOffset: CGFloat!
    var oldTopCst: CGFloat!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        playerVideoView.frame.origin.y = UIScreen.main.bounds.height
        print(playerVideoView.frame.origin.y)
        heightActionBar = actionBarHeightConstraint.constant
        contentCollectionView.register(UINib.init(nibName: "ContentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ContentCollectionViewCell")
        
        playerVideoView.delegate = self
        
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
        
        playerVideoView.show()
        
        
    }
}


extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        firstOffset = scrollView.contentOffset.y
        
        oldTopCst = actionBarTopConstraint.constant
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if check {
            return
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        let offsetY = scrollView.contentOffset.y
        var delta = offsetY - firstOffset - oldTopCst
        delta = min(delta, heightActionBar)
        delta = max(0, delta)
        actionBarTopConstraint.constant = -delta
        
        perform(#selector(scrollViewDidEndDecelerating(_:)), with: scrollView, afterDelay: 0.1)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        check = true
        
        if actionBarTopConstraint.constant > -heightActionBar/2 {
            actionBarTopConstraint.constant = 0
        } else {
            actionBarTopConstraint.constant = -heightActionBar
        }
        UIView.animate(withDuration: 0.18) {
            self.view.layoutIfNeeded()
        }
        check = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            actionBarTopConstraint.constant = -49
        } else if velocity.y < 0 {
            actionBarTopConstraint.constant = 0

        }
        UIView.animate(withDuration: 0.18) {
            self.view.layoutIfNeeded()
        }

    }
    
}

extension ViewController: PlayerVideoViewDelegate {
    func playerVideo(offset: CGFloat) {
        tabbedBarView.frame.origin.y = offset
    }
    
    func playerVideo(state: PlayerVideoState) {
        if state == .Full {
            tabbedBarView.frame.origin.y = UIScreen.main.bounds.height
        } else {
            tabbedBarView.frame.origin.y = UIScreen.main.bounds.height - 49
        }
        UIView.animate(withDuration: 0.18) {
            self.view.layoutIfNeeded()
        }
    }
    
    
}


