//
//  BBCTableViewCell.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 2/19/19.
//  Copyright © 2019 UIB. All rights reserved.
//

import UIKit

class BBCTableViewCell: UITableViewCell {

    @IBOutlet weak var mImage: ImageLoader!
    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
