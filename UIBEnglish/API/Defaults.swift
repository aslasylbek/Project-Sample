//
//  UserDefaultManager.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/19/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import Foundation

struct Defaults{
    
    static let (nameKey, addressKey) = ("name", "address")
    static let userSessionKey = "com.save.usersession"
    
    struct Model {
        var name: String?
        var address: String?
        
        init(_ json: [String: String]) {
            self.name = json[nameKey]
            self.address = json[addressKey]
        }
    }
    
    static var saveNameAndAddress = { (name: String, address: String) in
        UserDefaults.standard.set([nameKey: name, addressKey: address], forKey: userSessionKey)
    }
    
    static var getNameAndAddress = { _ -> Model in
        return Model((UserDefaults.standard.value(forKey: userSessionKey) as? [String: String]) ?? [:])
    }(())
    
    static func clearUserData(){
        UserDefaults.standard.removeObject(forKey: userSessionKey)
    }
    
    
}
