//
//  EditableListViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 2/20/19.
//  Copyright © 2019 UIB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditableListViewController: UIViewController {

    @IBOutlet weak var mTableLesson: UITableView!
    @IBOutlet weak var checkButton: DesignableButton!
    
    var delegate: PassLessonTaskResult!
    
    var taskId: Int!
    var lessonId: String!
    var allTask = [Transcript]()
    var allResult = [ResultBBC]()
    
    var inputTexts: [String] = [""]
    var isCheckAnswer: Bool = false
    var startTime: Double?
    var resultAns: Int = 0
    var answerArray: [String : String] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkButton.layer.shadowOpacity = 0.25
        checkButton.layer.shadowRadius = 5
        checkButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        for _ in 0..<allTask.count{
            inputTexts.append("")
        }
        startTime = NSDate().timeIntervalSince1970
    }
    
    @IBAction func onCheckOrFinishTouch(_ sender: DesignableButton) {
        if isCheckAnswer{
            delegate.setResult(result: resultAns, topicId: taskId)
        }
        else{
            self.view.endEditing(true)
            checkAnswerAndSend()
        }
    }
    
    private func updateUI(){
        isCheckAnswer = true
        mTableLesson.reloadData()
        checkButton.setTitle("Finish", for: UIControl.State.normal)
    }
    
    func checkAnswerAndSend() {
        for i in 0..<allTask.count{
            let pureText = inputTexts[i].trimmingCharacters(in: CharacterSet.whitespaces).lowercased()
            answerArray[allTask[i].id!] = pureText
        }
        sendListeningResult()
    }
    
    func sendListeningResult() {
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        showHUD("Sending")
        let params = ["user_id": user_id!,
                      "lesson_id": lessonId!,
                      "task_id": taskId!,
                      "start_time": startTime!,
                      "answer": answerArray] as [String : Any]
        
        Alamofire.request("http://de.uib.kz/post/bbc_questions.php",
                          method: .post,
                          parameters: params)
            .responseBBCAnswerModel { response in
                if let answerModel = response.result.value {
                    self.allResult = answerModel.results!
                    self.resultAns = answerModel.overall!
                    self.updateUI()
                    DispatchQueue.main.async {
                        self.hideHUD()
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.hideHUD()
                    }
                }
        }
    }
}

extension EditableListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTask.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellLesson", for: indexPath) as! BBCLessonTableCell
        if allTask[indexPath.row].definition==nil{
            cell.lblQuestion.text = allTask[indexPath.row].sentence
        }
        else{
            cell.lblQuestion.text = allTask[indexPath.row].definition
        }
        cell.tfAnswer.text = inputTexts[indexPath.row]
        cell.tfAnswer.tag = indexPath.row
        if isCheckAnswer{
            let pureText = inputTexts[indexPath.row].trimmingCharacters(in: CharacterSet.whitespaces).lowercased()
            cell.tfAnswer.isEnabled = false
            if pureText == allTask[indexPath.row].word{
                cell.tfAnswer.backgroundColor = UIColor(named: "correct")
            }
            else{
                cell.tfAnswer.backgroundColor = UIColor(named: "incorrect")
                cell.tfAnswer.text = allTask[indexPath.row].word
            }
        }
        return cell
    }
}

extension EditableListViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard textField.text != "" else {
            return false
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("Lalalal")
        inputTexts[textField.tag] = textField.text!
        return true
    }
}

class BBCLessonTableCell: UITableViewCell{

    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var tfAnswer: UITextField!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
