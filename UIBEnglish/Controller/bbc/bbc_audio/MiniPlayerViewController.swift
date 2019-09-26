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
    func playingNow(isPlaying: Bool)
}

class MiniPlayerViewController: UIViewController, SongSubscriber  {
    var subDelegate: NowPlayingViewControllerDelegate!
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
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(song: nil)
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player = nil
    }
    

    
}

// MARK: - Internal
extension MiniPlayerViewController {
    
    func configure(song: Song?) {
        var dur = 0.0
        if let song = song {
            songTitle.text = song.title
            if let imgUrl = song.mediaURL {
                thumbImage.loadImageWithUrl(imgUrl)
            }
            url = song.coverArtURL
            player = AVPlayer.init(url: url!)
            let asset = AVAsset(url: url!)
            dur = CMTimeGetSeconds(asset.duration)
            NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(note:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            
        } else {
            songTitle.text = nil
            thumbImage.image = nil
        }
        currentSong = song
        currentSong?.duration = dur
    }
    
    
}

// MARK: - IBActions
extension MiniPlayerViewController {
    
    // gesture handlers
    
    @IBAction func playAudioOrPause(_ sender: UIButton) {
        didPressPlayingButton(sender)
    }
    
    @IBAction func tapMiniGesture(_ sender: Any) {
        guard var song = currentSong else {
            return
        }
        song.isPlaying = playButton.isSelected
        delegate?.expandSong(song: song)
        
    }
    
    @IBAction func swipeMiniGesture(_ sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .up{
            guard let song = currentSong else {
                return
            }
            
            delegate?.expandSong(song: song)
        }
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

extension MiniPlayerViewController{
    // Media controller
    func didPressPlayingButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected ? player.play():player.pause()
        playButton.isSelected = sender.isSelected
        delegate?.playingNow(isPlaying: sender.isSelected)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Audio finished")
        playButton.isSelected = false
        delegate?.playingNow(isPlaying: false)
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 1000))
        
    }
    
    func didPressNextButton() {
        guard let duration = player.currentItem?.duration else {
            return
        }
        let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = playerCurrentTime+5
        if newTime < CMTimeGetSeconds(duration){
            let time2: CMTime = CMTimeMake(value: Int64(newTime*1000 as Float64), timescale: 1000)
            player.seek(to: time2)
        }
    }
    
    func didPressPreviousButton() {
        let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = playerCurrentTime - 5
        
        if newTime < 0 {
            newTime = 0
        }
        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale:  1000)
        player.seek(to: time2)
    }
}
