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
    var sortedCollection = WordsData()
    
    @IBOutlet weak var wordsTableView: UITableView!
    @IBOutlet weak var segmentControll: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "NothingFoundCell", bundle: nil)
        wordsTableView.register(cellNib, forCellReuseIdentifier: "NothingFound")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Wordbook"
        requestWordBookData()
    }
    
    func requestWordBookData()  {
        let defaults = UserDefaults.standard
        guard let courseId = defaults.string(forKey: "course_id")
            else{ return }
        guard let url = URL(string: "http://de.uib.kz/post/words_data.php")
            else {return}
        showHUD("Loading...")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let userId = defaults.string(forKey: "user_id")
       
        request.httpBody = "user_id=\(userId!)&course_id=\(courseId)".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.wordsDataTask(with: request) { wordsData, response, error in
            if let wordsData = wordsData {
                self.wordsCollection = wordsData
                DispatchQueue.main.async {
                    self.segmentControll.selectedSegmentIndex = 0
                    self.segmentControll.sendActions(for: .valueChanged)
                    //self.wordsTableView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.hideHUD()
            }
        }
        task.resume()
    }
    
    @IBAction func selectedSegmentControll(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sortedCollection.removeAll()
            for word in wordsCollection{
                if word.rating! == "0"{
                    sortedCollection.append(word)
                }
            }
            wordsTableView.reloadData()
        }
        else if sender.selectedSegmentIndex == 1 {
            sortedCollection.removeAll()
            for word in wordsCollection{
                if word.rating! != "0"{
                    sortedCollection.append(word)
                }
            }
            wordsTableView.reloadData()
        }
    }
}

extension WordsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedCollection.isEmpty ? 1 : sortedCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sortedCollection.isEmpty{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NothingFound", for: indexPath)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "wordsCell", for: indexPath) as! WordTableViewCell
            
            let word = sortedCollection[indexPath.row]
            cell.wordLabel.text = word.word
            cell.translateLabel.text = word.translateWord
            cell.transcriptionLabel.text = word.transcription
            
            //cell.wordLabel.backgroundColor = UIColor(white: 204/255, alpha: 1)
            //cell.wordLabel.textAlignment = .center
            //cell.arrowLabel.textColor = UIColor(white: 114 / 255, alpha: 1)
            cell.selectionStyle = .none
            cell.translateLabel.isHidden = word.isExpanded ? false : true
            cell.transcriptionLabel.isHidden = word.isExpanded ? false : true
            cell.soundButton.isHidden = word.isExpanded ? false : true
            cell.bottomConstraint.constant = word.isExpanded ? 80 : 10
            cell.arrowImage.transform = word.isExpanded ? CGAffineTransform(rotationAngle: CGFloat(Double.pi/2)) : CGAffineTransform(rotationAngle: CGFloat(2*Double.pi))
            
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
    
}

extension WordsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? WordTableViewCell else {
            return
        }
        var word = sortedCollection[indexPath.row]
        word.isExpanded = !word.isExpanded
        sortedCollection[indexPath.row] = word
        cell.translateLabel.isHidden = word.isExpanded ? false : true
        cell.transcriptionLabel.isHidden = word.isExpanded ? false : true
        cell.soundButton.isHidden = word.isExpanded ? false : true
        cell.bottomConstraint.constant = word.isExpanded ? 80 : 10
        cell.arrowImage.transform = word.isExpanded ? CGAffineTransform(rotationAngle: CGFloat(Double.pi/2)) : CGAffineTransform(rotationAngle: CGFloat(2*Double.pi))
        tableView.beginUpdates()
        tableView.endUpdates()
        //tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
    }
}


