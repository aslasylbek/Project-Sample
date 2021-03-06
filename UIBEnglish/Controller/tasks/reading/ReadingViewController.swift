//
//  ReadingViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 12/7/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

import AVFoundation


class ReadingViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tvArticle: UITextView!
    var readingData: ReadingModel?
    var topicId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvArticle.text = readingData?.reading!
        addCustomMenu()
    }
    
   
    override func viewWillLayoutSubviews() {
        tvArticle.setContentOffset(.zero, animated: true)
    }
   
    
    func addCustomMenu() {
        let addToWBMenu = UIMenuItem(title: "Add to Wordbook", action: #selector(addToWordBook))
        let definitionMenu = UIMenuItem(title: "Definition", action: #selector(requestForDefinition))
        let menuController = UIMenuController.shared
        menuController.menuItems = [addToWBMenu, definitionMenu]
    }
    
    
    
    @objc func addToWordBook() {
        if let range = tvArticle.selectedTextRange, let selectedText = tvArticle.text(in: range) {
            sendWordToServer(word: selectedText)
        }
        
    }
    
    func sendWordToServer(word: String){
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        let course_id = UserDefaults.standard.string(forKey: "course_id")
        showHUD("Adding...")
        let params = ["user_id": user_id!,
                      "course_id": course_id!,
                      "word": word] as [String : Any]
        
        Alamofire.request("http://de.uib.kz/post/user_word_data.php",
                          method: .post,
                          parameters: params)
            .responseJSON { response in
                if let value = response.result.value {
                    let json = JSON(value)
                    if json["success"].int == 1{
                    }
                    else if json["success"].int==0{
                    }
                    self.hideHUD()
                    self.showCompleteHUD("Successfully added")
                }
                else{
                    print("Error cabrone")
                }
                    //self.hideHUD()
        }
    }
    
    @objc func requestForDefinition() {
        if let range = tvArticle.selectedTextRange, let selectedText = tvArticle.text(in: range) {
            performSegue(withIdentifier: "definition", sender: selectedText)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "definition" {
            if let controller = segue.destination as? DefinitionViewController {
                controller.mWord = sender as! String
                controller.delegate = self
            }
        }
    }
    
}

extension ReadingViewController: NotifyAddToWordbook{
    func sendAddingWord(word: String) {
        sendWordToServer(word: word)
    }
}







