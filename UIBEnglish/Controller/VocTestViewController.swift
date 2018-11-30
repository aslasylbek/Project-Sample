//
//  VocTestViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/28/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import AVFoundation

protocol PassVocabulatyResultToParent {
    func passResult(result: Int)
}

class VocTestViewController: UIViewController {
    
    var allData = [Word]()
    var word: Word?
    var questionNumber: Int = 0
    var score: Int = 0
    var selectedAnswer: Int = 0
    
    var topicId: String?
    var taskId: Int?
    
    var delegate: PassVocabulatyResultToParent!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var questionStackView: UIView!
    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!
    
    var buttons: [UIButton] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [optionA, optionB, optionC, optionD]
        let playButton = PlayPauseButton(frame: CGRect(x: questionStackView.center.x - 100/2,
                                                       y: questionStackView.center.y - 100/2,
                                                       width: 100,
                                                       height: 100))
        
        //questionStackView.addSubview(playButton)
        playButton.setPlaying(true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserEnglishData()
    }
    
    private func getUserEnglishData(){
        //lessonsData.removeAll()
        let url = URL(string: "http://moodle.uib.kz/mobile_eng/data.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        request.httpBody = "user_id=\(user_id!)".data(using: String.Encoding.utf8)
        let session = URLSession.shared.englishDataTask(with: request) { (englishData, response, error) in
            if let englishData = englishData {
                let words = englishData.english![0].topics![0].words
                self.allData = words!
                UserDefaults.standard.setValue(englishData.english![0].courseID!, forKey: "course_id")
                DispatchQueue.main.async {
                    //CustomLoader.instance.hideLoader()
                    self.updateQuestion()
                    self.updateUI()
                }
            }
            else{
                
            }
        }
        session.resume()
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
            print(selectedAnswer)
            for i in 0...3{
                buttons[i].setTitle(fakeData[i].word, for: UIControl.State.normal)
                buttons[i].backgroundColor = UIColor.blue
                
            }
        } else{
            //Go to finish controller
            let resultPercent = 100*score/allData.count
            delegate.passResult(result: resultPercent)
        }
        updateUI()
        
    }
    
    func getShuffeled(choosen index: Int) -> [Word]{
        var recycledData = allData
        recycledData.remove(at: index)
        recycledData.shuffle()
        let subArray = recycledData[0...2]
        return Array(subArray)
    }
    
    func updateUI(){
        progressView.setProgress(1, animated: true)
    }
    
    @IBAction func choiceAnswer(_ sender: UIButton) {
        if sender.tag == selectedAnswer{
            sender.backgroundColor = UIColor.green
            score+=1
        }else{
            sender.backgroundColor = UIColor.red
            buttons[selectedAnswer-1].backgroundColor = UIColor.green
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            self.questionNumber+=1
            self.updateQuestion()
        }
    }
    
    @IBAction func playAudio(_ sender: UIButton) {
        let utterance = AVSpeechUtterance(string: (word?.word)!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    

}
