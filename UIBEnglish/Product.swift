//
//  Product.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 28.09.2018.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit

class Product: NSObject{
    var name: String!
    var type: String!
    var info: String!
    var imagePath: String!
    
    convenience init(name: String, type: String, imagePath: String, info: String) {
        self.init()
        self.name = name
        self.type = type
        self.imagePath = imagePath
        self.info = info
    }
    
    func getImage() -> UIImage? {
        return UIImage(named: self.imagePath)
    }
    
}
