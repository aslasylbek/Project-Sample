//
//  SongSubscriber.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 3/12/19.
//  Copyright © 2019 UIB. All rights reserved.
//

import Foundation

protocol SongSubscriber: class {
    var currentSong: Song? { get set }
    
    var subDelegate: NowPlayingViewControllerDelegate! { get set }
}
