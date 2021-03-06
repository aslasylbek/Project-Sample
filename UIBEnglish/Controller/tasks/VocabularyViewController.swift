//
//  VocabularyViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/27/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire


class VocabularyViewController: UIViewController {

    //MARK: Properties
    var allData = [Word]()
    var delegate: PassVocabulatyResultToParent!
    var topicId: String?
    
    @IBOutlet weak var rootStackView: UIStackView!
    
    @IBOutlet weak var wordImage: ImageLoader!
    
    @IBOutlet weak var mWordAudioButton: UIButton!
    @IBOutlet weak var mWord: UILabel!{
        didSet{
            mWord.text = wordObject?.word
        }
    }
    @IBOutlet weak var mWordTranscript: UILabel!{
        didSet{
            mWordTranscript.text = wordObject?.transcription
        }
    }
    @IBOutlet weak var mWordTranslate: UILabel!{
        didSet{
            mWordTranslate.text = wordObject?.translateWord
        }
    }
    
    var wordObject: Word?
    var cardNumber:Int = 0
    
    
    //MARK: Initiolaze
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootStackView.isHidden = true
        showHUD("Loading")
        //lessonsData.removeAll()
        let url = URL(string: "http://moodle.uib.kz/mobile_eng/data.php")
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        
        Alamofire.request(url!,
                          method: .post,
                          parameters: ["user_id": user_id!])
            .responseEnglishModel { response in
                if let englishData = response.result.value {
                    let topics = englishData.english![0].topics
                    for topic in topics!{
                        if topic.topicID == self.topicId{
                            let words = topic.words
                            self.allData = words!
                            UserDefaults.standard.setValue(englishData.english![0].courseID!, forKey: "course_id")
                            DispatchQueue.main.async {
                                //CustomLoader.instance.hideLoader()
                                self.rootStackView.isHidden = false
                                self.updateCard()
                                self.updateUI()
                                self.hideHUD()
                            }
                        }
                    }
                }
                else{
                    self.hideHUD()
                }
        }
    }
    
    func updateCard() {
        if cardNumber < allData.count{
            wordObject = allData[cardNumber]
            if let strUrl = wordObject?.picURL!, let imgUrl = URL(string: strUrl) {
                self.wordImage.loadImageWithUrl(imgUrl)
            }
            mWord.text = wordObject?.word
            mWordTranslate.text = wordObject?.translateWord
            mWordTranscript.text = wordObject?.transcription
        }
        else{
            delegate.notifyParent(status: 1)
        }
    }
    
    func updateUI() {
        
    }
    
    
    @IBAction func playAudio(_ sender: UIButton) {
        let utterance = AVSpeechUtterance(string: (wordObject?.word)!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    
    
    @IBAction func showNextCard(_ sender: UIButton) {
        cardNumber+=1
        updateCard()
    }
    
}
