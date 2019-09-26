//
//  ListeningViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 12/13/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation


class ListeningViewController: UIViewController {
    
    var allListening: ListeningModel?
    var allQuestions = [Questionanswer]()
    var topicId: String?
    var startTime: Double?
    var score: Int = 0
    var isRepaeat: Bool = false
    var delegate: PassVocabulatyResultToParent!
    let synth = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance(string: "")
    let boundary = AVSpeechBoundary(rawValue: 5)
    var inputTexts: [String] = [""]
    var isCheckAnswer: Bool = false
    var resultAns: Int = 0
    
    
    @IBOutlet weak var mFinishButton: UIButton!
    @IBOutlet weak var nowPlayingImageView: UIImageView!
    @IBOutlet weak var mPlayPauseButton: UIButton!
    @IBOutlet weak var mStopButton: UIButton!
    @IBOutlet weak var mRepeatButton: UIButton!
    @IBOutlet weak var listeningTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synth.delegate = self
        
        requestForListening()
        createNowPlayingAnimation()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listeningTable.estimatedRowHeight = 100
        listeningTable.rowHeight = UITableView.automaticDimension
    }
    
    func requestForListening() {
        guard let topicId = topicId else {
            return
        }
        showHUD("Process")
        Alamofire.request("http://de.uib.kz/post/get_listening.php",
                          method: .post,
                          parameters: ["topic_id": topicId])
            .responseListeningModel { (response) in
                if let listeningData = response.result.value {
                    print(listeningData)
//                    self.rootStackView.isHidden = false
                    self.allListening = listeningData[0]
                    if let questions = listeningData[0].questionanswer{
                        self.allQuestions = questions
                        self.listeningTable.reloadData()
                    }
                    self.startTime = NSDate().timeIntervalSince1970
                    self.updatePlayer()
                    self.hideHUD()
                }
                else{
                    self.hideHUD()
                }
        }
    }
    
    
    
    private func updatePlayer(){
        utterance = AVSpeechUtterance(string: (allListening?.listening)!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        for _ in 0..<allQuestions.count{
            inputTexts.append("")
        }
        
    }
    
    func createNowPlayingAnimation() {
        nowPlayingImageView.animationImages = AnimationFrames.createFrames()
        nowPlayingImageView.animationDuration = 0.7
    }
    
    func startNowPlayingAnimation(_ animate: Bool) {
        animate ? nowPlayingImageView.startAnimating() : nowPlayingImageView.stopAnimating()
    }
    
    @IBAction func playPauseClicked(_ sender: UIButton) {
        playerController()
    }
    
    func playerController() {
        if synth.isSpeaking && !synth.isPaused{
            mPlayPauseButton.isSelected = false
            synth.pauseSpeaking(at: AVSpeechBoundary.immediate)
        }
        else if synth.isPaused{
            mPlayPauseButton.isSelected = true
            synth.continueSpeaking()
        }
        else{
            mPlayPauseButton.isSelected = true
            synth.speak(utterance)
            
        }
        startNowPlayingAnimation(mPlayPauseButton.isSelected)
        
    }
    
    @IBAction func stopClicked(_ sender: UIButton) {
        if synth.isSpeaking || synth.isPaused{
            mPlayPauseButton.isSelected = false
            synth.stopSpeaking(at: AVSpeechBoundary.immediate)
            startNowPlayingAnimation(mPlayPauseButton.isSelected)
        }
        
    }
    
    @IBAction func repaetClicked(_ sender: UIButton) {
        if isRepaeat{
            isRepaeat = false
        }
        else{
            isRepaeat = true
        }
        mRepeatButton.isSelected = isRepaeat
    }
    
    @IBAction func finishTasks(_ sender: UIButton) {
        if isCheckAnswer{
            delegate.passResult(result: resultAns)
        }
        else{
            isCheckAnswer = true
            listeningTable.reloadData()
            mFinishButton.setTitle("END", for: UIControl.State.normal)
            self.view.endEditing(true)
            checkAnswerAndSend()
            
        }
    }
    
    func checkAnswerAndSend() {
        for i in 0..<allQuestions.count{
            let pureText = inputTexts[i].trimmingCharacters(in: CharacterSet.whitespaces).lowercased()
            if pureText == allQuestions[i].answer{
                score+=1
                print(score)
            }
        }
        resultAns = score * 100 / allQuestions.count
        sendListeningResult()
    }
    
    func sendListeningResult() {
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        showHUD("Sending")
        let params = ["user_id": user_id!,
                      "topic_id": topicId!,
                      "result_ans": resultAns,
                      "start_time": startTime!] as [String : Any]

        Alamofire.request("http://de.uib.kz/post/listening_questions.php",
                          method: .post,
                          parameters: params)
            .responseJSON { response in
                if let value = response.result.value {
                    let json = JSON(value)
                    //print(json["success"])
                    DispatchQueue.main.async {
                        self.hideHUD()
                        //self.delegate.passResult(result: resultPercent)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.hideHUD()
                        //self.delegate.passResult(result: resultPercent)
                    }
                }
        }
        
    }
  
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        synth.stopSpeaking(at: .immediate)
    }
}

extension ListeningViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListeningTableCell
        cell.lblQuestion.text = allQuestions[indexPath.row].question
        cell.tfAnswer.text = inputTexts[indexPath.row]
        cell.tfAnswer.tag = indexPath.row
        if isCheckAnswer{
            let pureText = inputTexts[indexPath.row].trimmingCharacters(in: CharacterSet.whitespaces).lowercased()
            cell.tfAnswer.isEnabled = false
            if pureText == allQuestions[indexPath.row].answer{
                cell.tfAnswer.backgroundColor = UIColor(named: "correct")
            }
            else{
                cell.tfAnswer.backgroundColor = UIColor(named: "incorrect")
            }
        }
        return cell
    }
}

extension ListeningViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard textField.text != "" else {
            return false
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        inputTexts[textField.tag] = textField.text!
        //let itemQuestion = allQuestions[textField.tag]
        return true
    }
    
    
}

extension ListeningViewController: AVSpeechSynthesizerDelegate{
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        mPlayPauseButton.isSelected = false
        startNowPlayingAnimation(false)
        
        if mRepeatButton.isSelected{
            playerController()
        }
    }
}


class ListeningTableCell: UITableViewCell{
    
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var tfAnswer: UITextField!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}



