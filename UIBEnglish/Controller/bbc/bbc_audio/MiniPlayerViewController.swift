//
//  MiniPlayerViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 3/12/19.
//  Copyright © 2019 UIB. All rights reserved.
//

import UIKit
import AVFoundation

protocol MiniPlayerDelegate: class {
    func expandSong(song: Song)
}

class MiniPlayerViewController: UIViewController, SongSubscriber  {
    
    var player: AVPlayer!
    
    var url : URL?
    
    var currentSong: Song?
    
    
    // MARK: - Properties
    weak var delegate: MiniPlayerDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var ffButton: UIButton!
    
    @IBOutlet weak var thumbImage: ImageLoader!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var playButton: UIButton!
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(song: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func playAudioOrPause(_ sender: Any) {
        player.play()
    }
    
}

// MARK: - Internal
extension MiniPlayerViewController {
    
    func configure(song: Song?) {
        if let song = song {
            songTitle.text = song.title
            if let imgUrl = song.mediaURL {
                thumbImage.loadImageWithUrl(imgUrl)
            }
            url = song.coverArtURL
            player = AVPlayer.init(url: url!)
        } else {
            songTitle.text = nil
            thumbImage.image = nil
        }
        currentSong = song
    }
}

// MARK: - IBActions
extension MiniPlayerViewController {
    
    @IBAction func tapMiniGesture(_ sender: Any) {
        guard let song = currentSong else {
            return
        }
        
        delegate?.expandSong(song: song)
    }
    
    
    
    
    
}

extension MiniPlayerViewController: MaxiPlayerSourceProtocol {
    var originatingFrameInWindow: CGRect {
        let windowRect = view.convert(view.frame, to: nil)
        return windowRect
    }
    
    var originatingCoverImageView: UIImageView {
        return thumbImage
    }
}

extension MiniPlayerViewController: NowPlayingViewControllerDelegate{
    func didPressPlayingButton() {
        player.pause()
    }
    
    func didPressStopButton() {
        
    }
    
    func didPressNextButton() {
        
    }
    
    func didPressPreviousButton() {
        
    }
    

}
