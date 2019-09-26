//
//  Song.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 3/12/19.
//  Copyright © 2019 UIB. All rights reserved.
//

import UIKit

struct Song {
    
    // MARK: - Properties
    let title: String
    var duration: TimeInterval = 0
    let artist: String
    var mediaURL: URL?
    var coverArtURL: URL?
    var isPlaying: Bool
}
