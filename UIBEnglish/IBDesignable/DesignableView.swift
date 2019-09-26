//
//  DesignableView.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 12/22/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {
    
        @IBInspectable var cornerRadius: CGFloat {
            set {
                layer.cornerRadius = newValue
            }
            get {
                return layer.cornerRadius
            }
        }

}
