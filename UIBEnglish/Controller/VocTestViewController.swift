//
//  VocTestViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/28/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

protocol PassVocabulatyResultToParent {
    func passResult(result: Int)
    func notifyParent(status: Int)
}

class VocTestViewController: UIViewController {
    
    var engLabel: UILabel?
    var answerTextField: UITextField?
    var allData = [Word]()
    var word: Word?
    var questionNumber: Int = 0
    var score: Int = 0
    var selectedAnswer: Int = 0
    var topicId: String?
    var taskId: Int?
    var exercise_id: String?
    var startTime: Double?
    var answerArray: [String : Int] = [:]
    
    var delegate: PassVocabulatyResultToParent!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var questionStackView: UIView!
    @IBOutlet weak var answerStackView: UIStackView!
    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!
    
    var buttons: [UIButton] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [optionA, optionB, optionC, optionD]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.questionStackView.isHidden = true
        self.answerStackView.isHidden = true
        getUserEnglishData()
        checkToRebuildUI()
    }
    
    private func getUserEnglishData(){
        //lessonsData.removeAll()
        showHUD("Loading")
        let url = URL(string: "http://moodle.uib.kz/mobile_eng/data.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        request.httpBody = "user_id=\(user_id!)".data(using: String.Encoding.utf8)
        let session = URLSession.shared.englishDataTask(with: request) { (englishData, response, error) in
            if let englishData = englishData {
                let topics = englishData.english![0].topics
                
                for topic in topics!{
                    if topic.topicID == self.topicId{
                        let words = topic.words
                        self.allData = words!
                    }
                }
                DispatchQueue.main.async {
                    //CustomLoader.instance.hideLoader()
                    self.startTime = NSDate().timeIntervalSince1970
                    self.questionStackView.isHidden = false
                    self.answerStackView.isHidden = false
                    self.updateQuestion()
                    self.hideHUD()
                }
            }
            else if error != nil{
                DispatchQueue.main.async {
                    self.hideHUD()
                }
            }
        }
        session.resume()
    }
    
    func checkToRebuildUI() {
        //for sending ch1, ch2, ch5, ch6
        exercise_id = "ch\(taskId!+1)"
        if taskId==2{
            exercise_id = "ch5"
            playButton.isHidden=true
            engLabel = UILabel(frame: CGRect(x: 0,
                                             y: questionStackView.center.y - 100/2,
                                             width: questionStackView.frame.width,
                                             height: 100))
            engLabel!.textAlignment = NSTextAlignment.center
            engLabel!.text = word?.word
            questionStackView.addSubview(engLabel!)
        }
        
        if taskId == 3{
            exercise_id = "ch6"
            for i in 0...3{
                buttons[i].isHidden = true
            }
            answerTextField = UITextField(frame: CGRect(x: 0,
                                                        y: answerStackView.center.y-answerStackView.frame.height/2,
                                                        width: answerStackView.frame.width,
                                                        height: 30))
            answerTextField?.placeholder = "Type audio"
            answerTextField?.font = UIFont.systemFont(ofSize: 15)
            answerTextField?.borderStyle = UITextField.BorderStyle.roundedRect
            answerTextField?.autocorrectionType = UITextAutocorrectionType.no
            answerTextField?.keyboardType = UIKeyboardType.default
            answerTextField?.returnKeyType = UIReturnKeyType.send
            answerTextField?.clearButtonMode = UITextField.ViewMode.whileEditing;
            answerTextField?.delegate = self
            answerStackView.addSubview(answerTextField!)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.answerStackView.layoutIfNeeded()
            answerStackView.frame.origin.y = -rootStackView.frame.height+keyboardHeight + questionStackView.frame.height
        }
    }
    
    func updateQuestion() {
        if questionNumber < allData.count{
            word = allData[questionNumber]
            var fakeData = getShuffeled(choosen: questionNumber)
            fakeData.append(word!)
            fakeData.shuffle()
            selectedAnswer =  fakeData.firstIndex { (item) -> Bool in
                item.id == word!.id
                }! + 1
            
            if taskId == 0{
                for i in 0...3{
                    buttons[i].setTitle(fakeData[i].word, for: UIControl.State.normal)
                    buttons[i].backgroundColor = UIColor.blue
                }
            }
            else if taskId==1{
                for i in 0...3{
                    buttons[i].setTitle(fakeData[i].translateWord, for: UIControl.State.normal)
                    buttons[i].backgroundColor = UIColor.blue
                }
            }
            else if taskId==2{
                engLabel?.text = word?.word
                for i in 0...3{
                    buttons[i].setTitle(fakeData[i].translateWord, for: UIControl.State.normal)
                    buttons[i].backgroundColor = UIColor.blue
                }
            }
            else if taskId==3{
                answerTextField?.text = ""
                answerTextField?.becomeFirstResponder()
                answerTextField?.backgroundColor = UIColor.clear
            }
            
            updateUI()
        } else{
            sendResult()
        }
        
    }
    
    func sendResult() {
        
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        let resultPercent = 100*score/allData.count
        showHUD("Process")
        let params = ["user_id": user_id!,
                      "exercise_id": exercise_id!,
                      "topic_id": topicId!,
                      "result": resultPercent,
                      "start_time": startTime!,
                      "q_ans": answerArray] as [String : Any]
        
        Alamofire.request("http://de.uib.kz/modules/online_lessons/add_results.php",
                          method: .post,
                          parameters: params)
            .responseJSON { response in
                if let value = response.result.value {
                    //let json = JSON(value)
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
    
    func getShuffeled(choosen index: Int) -> [Word]{
        var recycledData = allData
        recycledData.remove(at: index)
        recycledData.shuffle()
        let subArray = recycledData[0...2]
        return Array(subArray)
    }
    
    func updateUI(){
        let progress = Float(questionNumber+1)/Float(allData.count)
        progressView.setProgress(progress, animated: true)
    }
    
    @IBAction func choiceAnswer(_ sender: UIButton) {
        if sender.tag == selectedAnswer{
            sender.backgroundColor = UIColor.green
            score+=1
            answerArray[(word?.id)!] = 1
        }else{
            sender.backgroundColor = UIColor.red
            buttons[selectedAnswer-1].backgroundColor = UIColor.green
            answerArray[(word?.id)!] = 0
        }
        for i in 0...3{
            buttons[i].isUserInteractionEnabled = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            self.questionNumber+=1
            self.updateQuestion()
            for i in 0...3{
                self.buttons[i].isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func playAudio(_ sender: UIButton) {
        let utterance = AVSpeechUtterance(string: (word?.word)!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    

}

extension VocTestViewController: UITextFieldDelegate{
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
     
        guard let inputText = textField.text,
            textField.text != "" else {
            return false
        }
        
        let pureText = inputText.trimmingCharacters(in: CharacterSet.whitespaces).lowercased()
        
        if pureText == word?.word{
            answerArray[(word?.id)!] = 1
            score+=1
            textField.backgroundColor = UIColor.green
        }
        else{
            textField.backgroundColor = UIColor.red
            answerArray[(word?.id)!] = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.questionNumber+=1
            self.updateQuestion()
        }
        resignFirstResponder()
        return true
    }
    
}
