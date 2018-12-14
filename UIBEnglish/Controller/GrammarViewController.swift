//
//  GrammarViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 12/5/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GrammarViewController: UIViewController {
    
    
    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var svQuestion: UIStackView!
    @IBOutlet weak var progressQuestion: UIProgressView!
    @IBOutlet weak var scroolView: UIScrollView!
    
    var allGrammar = [GrammarModel]()
    var itemGrammar: GrammarModel?
    var questionNumber: Int = 0
    var score: Int = 0
    var taskId: Int?
    var topicId: String?
    var startTime: Double?
    var splittedAns: [String]?
    var correctnesSen: Int = 0
    var answerTextField: UITextField?
    var progressCounter: Int = 0
    
    var resultAns: Int = 0
    var resultCons: Int = 0
    
    var delegate: PassVocabulatyResultToParent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootStackView.isHidden=true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        requestForGrammar()
    }
    
    //MARK: request
    func requestForGrammar() {
        showHUD("Process")
        Alamofire.request("http://de.uib.kz/post/get_grammatika.php",
                          method: .post,
                          parameters: ["topic_id": topicId!])
            .responseGrammarData { (response) in
                if let grammarData = response.result.value {
                    self.rootStackView.isHidden = false
                    self.allGrammar = grammarData
                    self.startTime = NSDate().timeIntervalSince1970
                    self.updateQuestion()
                    self.hideHUD()
                }
                else{
                    self.hideHUD()
                }
        }
    }
    
    func rebuildView()  {
        lblQuestion.textColor = UIColor.black
        lblAnswer.textColor = UIColor.black
        lblAnswer.text?.removeAll()
        svQuestion.isHidden = true
        
        answerTextField = UITextField(frame: CGRect(x: 0,
                                                    y: scroolView.center.y-scroolView.frame.height/2,
                                                    width: scroolView.frame.width,
                                                    height: 30))
        answerTextField?.placeholder = "Type missing word"
        answerTextField?.font = UIFont.systemFont(ofSize: 15)
        answerTextField?.borderStyle = UITextField.BorderStyle.roundedRect
        answerTextField?.autocorrectionType = UITextAutocorrectionType.no
        answerTextField?.keyboardType = UIKeyboardType.default
        answerTextField?.returnKeyType = UIReturnKeyType.send
        answerTextField?.clearButtonMode = UITextField.ViewMode.whileEditing;
        answerTextField?.delegate = self
        scroolView.addSubview(answerTextField!)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        updateQuestion()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            scroolView.frame.origin.y = -rootStackView.frame.height+keyboardHeight + scroolView.frame.height
        }
    }
    
    func updateQuestion() {
        if questionNumber<allGrammar.count{
            lblQuestion.textColor = UIColor.black
            lblAnswer.textColor = UIColor.black
            lblAnswer.text?.removeAll()
            itemGrammar = allGrammar[questionNumber]
            if taskId==1{
                correctnesSen = 0
                lblQuestion.text = itemGrammar?.translate
                splittedAns = itemGrammar?.sentence?.components(separatedBy: " ")
                var shuffledAns = splittedAns
                shuffledAns?.shuffle()
                
                for title in 0..<shuffledAns!.count{
                    let button = UIButton()
                    button.tag = (splittedAns?.index(of: shuffledAns![title]))!
                    button.backgroundColor = UIColor.blue
                    button.setTitle(shuffledAns![title], for: .normal)
                    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                    self.svQuestion.addArrangedSubview(button)
                }
                
            }
            else if taskId == 2{
                lblQuestion.text = itemGrammar?.question
                answerTextField?.text = ""
                answerTextField?.becomeFirstResponder()
                answerTextField?.backgroundColor = UIColor.clear
            }
            updateUI()
        }
        else if taskId==1{
            resultCons = score
            taskId = 2
            questionNumber = 0
            rebuildView()

        }
        else{
            resultAns = (score-resultCons)*100/allGrammar.count
            resultCons = resultCons*100/allGrammar.count
            sendResult()
        }
        
    }
  
    @objc func buttonAction(sender: UIButton!) {
        if sender.tag == correctnesSen{
            correctnesSen += 1
        }
        lblAnswer.text?.append(" \((sender.titleLabel?.text)!)")
        sender.removeFromSuperview()
        
        if svQuestion.subviews.count==0 {
            if correctnesSen == splittedAns?.count{
                lblAnswer.textColor = UIColor.green
                score+=1
            }
            else{
                lblQuestion.text = itemGrammar?.sentence
                lblQuestion.textColor = UIColor.green
                lblAnswer.textColor = UIColor.red
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                self.questionNumber+=1
                self.updateQuestion()
            })
        }
    }
    
    func updateUI() {
        progressCounter+=1
        let progress = Float(progressCounter)/Float(allGrammar.count*2)
        progressQuestion.setProgress(progress, animated: true)
    }
    
    func sendResult() {
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        let resultPercent = 100*score/(allGrammar.count*2)
        showHUD("Process")
        let params = ["user_id": user_id!,
                      "topic_id": topicId!,
                      "result_ans": resultAns,
                      "start_time": startTime!,
                      "result_cons": resultCons] as [String : Any]
        
        Alamofire.request("http://de.uib.kz/post/grammatika_questions.php",
                          method: .post,
                          parameters: params)
            .responseJSON { response in
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json["success"])
                    DispatchQueue.main.async {
                        self.hideHUD()
                        self.delegate.passResult(result: resultPercent)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.hideHUD()
                        self.delegate.passResult(result: resultPercent)
                    }
                    
                }
        }
        
    }
    

}

extension GrammarViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        
        guard let inputText = textField.text,
            textField.text != "" else {
                return false
        }
        
        let pureText = inputText.trimmingCharacters(in: CharacterSet.whitespaces).lowercased()
        
        if pureText == itemGrammar?.answer{
            //answerArray[(word?.id)!] = 1
            score+=1
            textField.backgroundColor = UIColor.green
        }
        else{
            textField.backgroundColor = UIColor.red
            //answerArray[(word?.id)!] = 0
        }
        textField.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.questionNumber+=1
            self.updateQuestion()
        }
        
        return true
    }
}


