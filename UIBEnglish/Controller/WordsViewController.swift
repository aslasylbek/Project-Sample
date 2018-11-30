//
//  WordsViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/22/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import AVFoundation

class WordsViewController: UIViewController {

    var wordsCollection =  WordsData()
    
    @IBOutlet weak var wordsTableView: UITableView!
    
    let moreInfoText = "Select for more Info"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let url = URL(string: "http://de.uib.kz/post/words_data.php")
            else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let defaults = UserDefaults.standard
        let userId = defaults.string(forKey: "user_id")
        let courseId = defaults.string(forKey: "course_id")
        request.httpBody = "user_id=\(userId!)&course_id=\(5606)".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.wordsDataTask(with: request) { wordsData, response, error in
            if let wordsData = wordsData {
               self.wordsCollection = wordsData
                DispatchQueue.main.async {
                    self.wordsTableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
  

}

extension WordsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordsCell", for: indexPath) as! WordTableViewCell
        
        let word = wordsCollection[indexPath.row]
        
        cell.wordLabel.text = word.word
        cell.translateLabel.text = word.translateWord
        cell.transcriptionLabel.text = word.transcription
        
        //cell.wordLabel.backgroundColor = UIColor(white: 204/255, alpha: 1)
        cell.wordLabel.textAlignment = .center
        //cell.arrowLabel.textColor = UIColor(white: 114 / 255, alpha: 1)
        cell.selectionStyle = .none
        
        cell.translateLabel.isHidden = word.isExpanded ? false : true
        cell.transcriptionLabel.isHidden = word.isExpanded ? false : true
        cell.soundButton.isHidden = word.isExpanded ? false : true
        
        cell.yourobj = {
            
            let utterance = AVSpeechUtterance(string: word.word!)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            let synth = AVSpeechSynthesizer()
            synth.speak(utterance)
        }
        
//        cell.arrowLabel.text = wordsCollection.isExpanded ? word.translate_word : moreInfoText
//        cell.arrowLabel.textAlignment = wordsCollection.isExpanded ? .left : .center
        
        cell.wordLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        //cell.arrowLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        
        return cell
    }
    
}

extension WordsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? WordTableViewCell else {
            return
        }
        var word = wordsCollection[indexPath.row]
        
        
        word.isExpanded = !word.isExpanded
        wordsCollection[indexPath.row] = word
        cell.translateLabel.isHidden = word.isExpanded ? false : true
        cell.transcriptionLabel.isHidden = word.isExpanded ? false : true
        cell.soundButton.isHidden = word.isExpanded ? false : true
        cell.bottomConstraint.constant = word.isExpanded ? 130 : 0
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
    }
}


