//
//  DefinitionViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 12/7/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

protocol NotifyAddToWordbook {
    func sendAddingWord(word: String)
}
class DefinitionViewController: UIViewController {

    var mWord: String?
    var wordData: LinguoWordModel?
    var delegate: NotifyAddToWordbook!
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var tvTranslates: UITextView!
    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var lblTranscript: UILabel!
    @IBOutlet weak var btnSound: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSound.isHidden = true
        lblTranscript.isHidden = true
        lblWord.isHidden = true
        btnAdd.isEnabled = false
        requestLingua()
        
    }
    
    func requestLingua()  {
        showHUD("Requesting")
        let params = ["word": mWord] as! [String : String]
        Alamofire.request("http://api.lingualeo.com/gettranslates",
                          method: .get,
                          parameters: params)
            .responseLinguoWordModel { response in
                if let linguoWordModel = response.result.value {
                    self.wordData = linguoWordModel
                    self.lblTranscript.isHidden = false
                    self.lblWord.isHidden = false
                    if (linguoWordModel.wordForms?.count)! > 0{
                        self.updateUI()
                        self.btnAdd.isEnabled = true
                    }
                }
                else{
                    print("Error cabrone")
                }
                self.hideHUD()
        }
    }
    
    func updateUI() {
        lblWord.text = wordData?.wordForms![0].word
        lblTranscript.text = wordData?.transcription
        if wordData?.soundURL != ""{
            btnSound.isHidden = false
        }
        guard (wordData?.translate?.count)!>0 else {
            return
        }
        for translate in (wordData?.translate)! {
            tvTranslates.text.append("  - \(translate.value!)\n")
        }
        
    }
    
    

    @IBAction func playAudio(_ sender: UIButton) {
        let utterance = AVSpeechUtterance(string: (wordData?.wordForms![0].word)!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    @IBAction func addToWordbook(_ sender: UIButton) {
        delegate.sendAddingWord(word: mWord!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
