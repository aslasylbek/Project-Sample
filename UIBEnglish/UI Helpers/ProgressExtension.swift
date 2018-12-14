//
//  ProgressExtension.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 12/5/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class ProgressExtension{
    
    
}

extension UITableViewController {
    func showHUDForTable(_ message: String?) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        if (message != nil) {hud.label.text = message}
        hud.isUserInteractionEnabled = false
        hud.layer.zPosition = 2
        hud.contentColor = UIColor.green
        hud.bezelView.color = .clear
        self.tableView.layer.zPosition = 1
    }
}

extension UICollectionViewController {
    func showHUDForCollectionView(_ message: String?) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        if (message != nil) {hud.label.text = message}
        hud.isUserInteractionEnabled = false
        hud.layer.zPosition = 2
        hud.bezelView.color = .clear
        hud.contentColor = UIColor.green
        self.collectionView.layer.zPosition = 1
    }
}

extension UIViewController {
    func showHUD(_ message: String?) {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        if (message != nil) {hud.label.text = message}
        hud.bezelView.color = .clear
        hud.contentColor = UIColor.green
        hud.isUserInteractionEnabled = false
    }
    
    func hideHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}

extension UITextView{
    open override func canPerformAction(_ action: Selector, withSender
        sender: Any?) -> Bool {
        return false
    }
}
