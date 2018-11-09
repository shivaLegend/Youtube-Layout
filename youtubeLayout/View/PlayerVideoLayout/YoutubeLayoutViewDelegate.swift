//
//  PlayerVideoViewDelegate.swift
//  youtubeLayout
//
//  Created by Nguyen Duc Tai on 11/2/18.
//  Copyright © 2018 Nguyen Duc Tai. All rights reserved.
//

import UIKit

enum PlayerVideoState {
    case Full, Mini
}

protocol YoutubeLayoutViewDelegate {
    func playerVideo(state: PlayerVideoState)
    func playerVideo(offset: CGFloat)
}
