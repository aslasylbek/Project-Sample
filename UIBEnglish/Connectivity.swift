//
//  Connectivity.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 4/23/19.
//  Copyright © 2019 UIB. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
