//
//  WordTableViewCell.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/22/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit

class WordTableViewCell: UITableViewCell {

    var yourobj : (() -> Void)? = nil
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var translateLabel: UILabel!
    @IBOutlet weak var transcriptionLabel: UILabel!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func listenToAudio(_ sender: UIButton) {
        if let btnAction = self.yourobj
        {
            btnAction()
        }
    }
}
