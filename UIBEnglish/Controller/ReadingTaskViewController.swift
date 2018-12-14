//
//  ReadingTaskViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 12/10/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReadingTaskViewController: UIViewController {

    var allReading: ReadingModel?
    var delegate: PassVocabulatyResultToParent!
    var questionAnswer: Questionanswer?
    var trueFalse: Truefalse?
    var questionNumber: Int = 0
    var score: Int = 0
    var topicId: String?
    var resultAns: Int = 0
    var resultTf: Int = 0
    var startTime: Double?
    
    
    var btnTrue: UIButton?
    var btnFalse: UIButton?
    
    var progressCounter: Int = 0
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var tfAnswer: UITextField!
    @IBOutlet weak var svAnswer: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfAnswer.delegate = self
        startTime = NSDate().timeIntervalSince1970
        if (allReading?.questionanswer!.count)! > 0 {
            updateQuestion()
        }
        else{
            rebuildUIForTrueFalse()
        }
    }
    
    func rebuildUIForTrueFalse() {
        tfAnswer.isHidden = true
        btnTrue = UIButton()
        btnTrue!.backgroundColor = UIColor.blue
        btnTrue!.setTitle("True", for: .normal)
        btnTrue!.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.svAnswer.addArrangedSubview(btnTrue!)
        
        btnFalse = UIButton()
        btnFalse!.backgroundColor = UIColor.blue
        btnFalse!.setTitle("False", for: .normal)
        btnFalse!.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.svAnswer.addArrangedSubview(btnFalse!)
        updateTrueFalse()
    }
    
    
    @objc func buttonAction(sender: UIButton!) {
        
        if sender.tag != 0{
            sender.backgroundColor = UIColor.green
            score+=1
        }
        else{
            sender.backgroundColor = UIColor.red
            if let correctBtn = svAnswer.viewWithTag(Int((trueFalse?.id)!)!) as? UIButton{
                correctBtn.backgroundColor = UIColor.green
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                            self.questionNumber+=1
                            self.updateTrueFalse()
                        })
    }
    
    
    func updateTrueFalse() {
        if questionNumber < (allReading?.truefalse?.count)!{
            //null view data
            btnTrue?.backgroundColor = UIColor.blue
            btnFalse?.backgroundColor = UIColor.blue
            btnFalse?.tag = 0
            btnTrue?.tag = 0
            
            trueFalse = allReading?.truefalse?[questionNumber]
            lblQuestion.text = trueFalse?.question
            //set view data
            if trueFalse?.truefalse! == "0"{
                btnFalse!.tag = Int((trueFalse?.id)!)!
            }
            else if trueFalse?.truefalse! == "1"{
                btnTrue!.tag = Int((trueFalse?.id)!)!
            }
            updateUI()
        }
        else{
            // send answer to server and notify parent
            resultTf = (score - resultAns) * 100 / (allReading?.truefalse!.count)!
            sendReadingResult()
            
        }
    }
    
    func updateQuestion()  {
        if questionNumber < (allReading?.questionanswer?.count)!{
            questionAnswer = allReading?.questionanswer![questionNumber]
            tfAnswer.backgroundColor = UIColor.clear
            tfAnswer.becomeFirstResponder()
            tfAnswer.text = ""
            lblQuestion.text = questionAnswer?.question
            updateUI()
        }
        else if (allReading?.truefalse?.count)!>0{
            resultAns = score
            questionNumber = 0
            rebuildUIForTrueFalse()
        }
        else{
            resultAns = score
            sendReadingResult()
        }
    }
    
    func updateUI()  {
        progressCounter += 1
        let progress = Float(progressCounter)/Float((allReading?.questionanswer!.count)! + (allReading?.truefalse?.count)!)
        progressView.setProgress(progress, animated: true)
    }
    
    
    func sendReadingResult() {
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        resultAns = resultAns * 100 / (allReading?.questionanswer!.count)!
        let resultPercent = 100*score/((allReading?.questionanswer!.count)!+(allReading?.truefalse!.count)!)
        
        showHUD("Process")
        let params = ["user_id": user_id!,
                      "topic_id": topicId!,
                      "result_ans": resultAns,
                      "start_time": startTime!,
                      "result_tf": resultTf] as [String : Any]
        
        Alamofire.request("http://de.uib.kz/post/reading_questions.php",
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

extension ReadingTaskViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        
        guard let inputText = textField.text,
            textField.text != "" else {
                return false
        }
        
        let pureText = inputText.trimmingCharacters(in: CharacterSet.whitespaces).lowercased()
        
        if pureText == questionAnswer?.answer{
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
