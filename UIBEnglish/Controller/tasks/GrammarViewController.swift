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
    
    //var allGrammar = [GrammarModel]()
    var itemGrammar: GrammarModel?
    var misswordData = [Missword]()
    var constructorData = [Constructor]()
    var itemConstructor: Constructor?
    var itemMissword: Missword?
    
    var questionNumber: Int = 0
    var questionMissNumber: Int = 0
    var score: Int = 0
    var taskId: Int?
    var topicId: String?
    var startTime: Double?
    var splittedAns: [String]?
    var correctnesSen: Int = 0
    var answerTextField: UITextField?
    var progressCounter: Int = 0
    var usedButtonCounts = 0
    
    var resultAns: Int = -1
    var resultCons: Int = -1
    
    var delegate: PassVocabulatyResultToParent!
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        rootStackView.isHidden=true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(undoLastChanges))
        lblAnswer.isUserInteractionEnabled = true
        lblAnswer.addGestureRecognizer(tapGesture)
    }
    
    @objc func undoLastChanges()  {
        lblAnswer.text = ""
        usedButtonCounts = 0
        correctnesSen = 0
        for i in svQuestion.subviews {
            i.isHidden = false
        }
        
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
            .responseGrammarModel { (response) in
                if let grammarData = response.result.value {
                    self.rootStackView.isHidden = false
                    self.misswordData = grammarData[0].missword!
                    self.constructorData = grammarData[0].constructor!
                    self.startTime = NSDate().timeIntervalSince1970
                    self.updateQuestion()
                }
                self.hideHUD()
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
        if questionNumber<constructorData.count{
            lblQuestion.textColor = UIColor.black
            lblAnswer.textColor = UIColor.black
            lblAnswer.text?.removeAll()
            itemConstructor = constructorData[questionNumber]
            usedButtonCounts = 0
            for clearButton in svQuestion.arrangedSubviews{
                clearButton.removeFromSuperview()
            }
                correctnesSen = 0
                lblQuestion.text = itemConstructor?.translate
                splittedAns = itemConstructor?.sentence?.components(separatedBy: " ")
                var shuffledAns = splittedAns
                shuffledAns?.shuffle()
                
                for title in 0..<shuffledAns!.count{
                    let button = UIButton()
                    button.tag = (splittedAns?.index(of: shuffledAns![title]))!
                    button.backgroundColor = UIColor(named: "primary")
                    button.setTitle(shuffledAns![title], for: .normal)
                    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                    self.svQuestion.addArrangedSubview(button)
                }
            
            updateUI()
        }
        else if taskId==1{
            if constructorData.count>0{
                resultCons = score*100/constructorData.count
            }
            taskId = 2
            //questionNumber = 0
            if misswordData.count>0{
               rebuildView()
            }
        }
        else if questionMissNumber<misswordData.count{
            itemMissword = misswordData[questionMissNumber]
            lblQuestion.text = itemMissword?.question
            answerTextField?.text = ""
            answerTextField?.becomeFirstResponder()
            answerTextField?.backgroundColor = UIColor.clear
            updateUI()
        }
        else{
            if misswordData.count>0{
                resultAns = (score-resultCons)*100/misswordData.count
            }
            sendResult()
        }
        
    }
  
    @objc func buttonAction(sender: UIButton!) {
        usedButtonCounts+=1
        if sender.tag == correctnesSen{
            correctnesSen += 1
        }
        lblAnswer.text?.append(" \((sender.titleLabel?.text)!)")
        sender.isHidden = true
        if svQuestion.subviews.count == usedButtonCounts {
            if correctnesSen == splittedAns?.count{
                lblAnswer.textColor = UIColor(named: "correct")
                score+=1
            }
            else{
                lblQuestion.text = itemConstructor?.sentence
                lblQuestion.textColor = UIColor(named: "correct")
                lblAnswer.textColor = UIColor(named: "incorrect")
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                self.questionNumber+=1
                self.updateQuestion()
            })
        }
    }
    
    func updateUI() {
        progressCounter+=1
        let progress = Float(progressCounter)/Float(misswordData.count+constructorData.count)
        progressQuestion.setProgress(progress, animated: true)
    }
    
    func sendResult() {
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        let resultPercent = 100*score/(misswordData.count+constructorData.count)
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
        
        if pureText == itemMissword?.answer{
            //answerArray[(word?.id)!] = 1
            score+=1
            textField.backgroundColor = UIColor(named: "correct")
        }
        else{
            textField.backgroundColor = UIColor(named: "incorrect")
            //answerArray[(word?.id)!] = 0
        }
        textField.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.questionMissNumber+=1
            self.updateQuestion()
        }
        
        return true
    }
}


