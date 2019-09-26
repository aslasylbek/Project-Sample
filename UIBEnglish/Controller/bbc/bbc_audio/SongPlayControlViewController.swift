//
//  SongPlayControlViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 3/12/19.
//  Copyright © 2019 UIB. All rights reserved.
//

import UIKit

protocol NowPlayingViewControllerDelegate: class {
    func didPressPlayingButton(_ sender: UIButton)
    func didPressStopButton()
    func didPressNextButton()
    func didPressPreviousButton()
}

class SongPlayControlViewController: UIViewController, SongSubscriber {
    
    // MARK: - IBOutlets
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var songDuration: UILabel!
    @IBOutlet weak var btnPlayPause: UIButton!
    
    // MARK: - Properties
    var currentSong: Song? {
        didSet {
            configureFields()
        }
    }
    
    var subDelegate: NowPlayingViewControllerDelegate!{
        didSet{
            
        }
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFields()
    }
    
    @IBAction func playingPressed(_ sender: UIButton) {
        subDelegate?.didPressPlayingButton(sender)
    }
    @IBAction func nextForwardPressed(_ sender: Any) {
        subDelegate?.didPressNextButton()
    }
    @IBAction func previousPressed(_ sender: Any) {
        subDelegate?.didPressPreviousButton()
    }
    
}

// MARK: - Internal
extension SongPlayControlViewController {
    
    func configureFields() {
        guard songTitle != nil else {
            return
        }
        btnPlayPause.isSelected = (currentSong?.isPlaying)!
        songTitle.text = currentSong?.title
        songArtist.text = currentSong?.artist
        songDuration.text = "Duration \(currentSong?.presentationTime ?? "")"
    }
}

// MARK: - Song Extension
extension Song {
    
    var presentationTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        let date = Date(timeIntervalSince1970: duration)
        return formatter.string(from: date)
    }
}
