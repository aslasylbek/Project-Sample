//
//  MenuTableViewCell.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/14/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var imageVIewCell: UIImageView!
    @IBOutlet weak var labelCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageVIewCell.layer.cornerRadius = 40
        imageVIewCell.clipsToBounds = true
        imageVIewCell.contentMode = .scaleToFill
        imageVIewCell.backgroundColor = UIColor.lightGray
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
