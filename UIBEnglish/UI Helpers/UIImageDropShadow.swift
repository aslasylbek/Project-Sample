//
//  UIImageDropShadow.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 12/19/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit

extension UIImageView {
    
    // APPLY DROP SHADOW
    func applyShadow() {
        let layer           = self.layer
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.4
        layer.shadowRadius  = 2
    }
    
}
