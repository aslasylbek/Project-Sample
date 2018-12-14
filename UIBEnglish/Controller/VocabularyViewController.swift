//
//  VocabularyViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/27/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import AVFoundation


class VocabularyViewController: UIViewController {

    //MARK: Properties
    var allData = [Word]()
    var delegate: PassVocabulatyResultToParent!
    var topicId: String?
    
    @IBOutlet weak var rootStackView: UIStackView!
    
    @IBOutlet weak var wordImage: ImageLoader!{
        didSet{
            guard let image = wordObject?.picURL else {
                return
            }
            wordImage.image = downloadImage(image)
        }
    }
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
        session.resume()
        //wordImage.image = downloadImage((wordObject?.picURL)!)
    }
    
    func updateCard() {
        if cardNumber<allData.count{
            wordObject = allData[cardNumber]
            if let strUrl = wordObject?.picURL!, let imgUrl = URL(string: strUrl) {
                self.wordImage.loadImageWithUrl(imgUrl)
            }
            wordImage.image = downloadImage((wordObject?.picURL)!)
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
    
    
    func downloadImage(_ url: String) -> (UIImage) {
        guard let aURL = URL(string: url) else {
            return UIImage()
        }
        guard let data = try? Data(contentsOf: aURL) else {
            return UIImage()
        }
        let image = UIImage(data: data)
        return image!
    }
    
    @IBAction func showNextCard(_ sender: UIButton) {
        cardNumber+=1
        updateCard()
    }
    
}
