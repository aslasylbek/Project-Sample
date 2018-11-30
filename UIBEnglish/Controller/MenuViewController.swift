//
//  MenuViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/14/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import ProgressHUD

class MenuViewController: UIViewController {

    @IBOutlet weak var expandTableView: UITableView!
    var lessonsData = [Topic]()
    var refresh = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
        expandTableView.estimatedRowHeight = 30
        expandTableView.rowHeight = 90
        
        self.refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        expandTableView.addSubview(refresh)
        
      
    }
    
    @objc func handleRefresh()  {
        getUserEnglishData()
        refresh.endRefreshing()
//        let indexPathNewRow = IndexPath(row: lessonsData.count-1, section: 0)
//        expandTableView.insertRows(at: [indexPathNewRow], with: .automatic)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserEnglishData()
        
    }
    
    private func getUserEnglishData(){
        ProgressHUD.show()
        let url = URL(string: "http://moodle.uib.kz/mobile_eng/data.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        request.httpBody = "user_id=\(user_id!)".data(using: String.Encoding.utf8)
        let session = URLSession.shared.englishDataTask(with: request) { (englishData, response, error) in
            if let englishData = englishData {
                guard let english = englishData.english,
                english.count>0 else { return }
                let topics = english[0].topics
                self.lessonsData = topics!
                UserDefaults.standard.setValue(english[0].courseID!, forKey: "course_id")
                DispatchQueue.main.async {
                    self.expandTableView.reloadData()
                    ProgressHUD.dismiss()
                }
            }
            else{
                ProgressHUD.dismiss()
            }
        }
        session.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTasks" {
            let navVC = segue.destination as! UINavigationController
            let vc = navVC.viewControllers.first as! SubmenuViewController
            let indexPath = expandTableView.indexPathForSelectedRow
            if let indexPath = indexPath {
                vc.lessonData = lessonsData[indexPath.row]
            }
        }
    }
    
    func setMessageLabel(_ messageLabel: UILabel, frame: CGRect, text: String, textColor: UIColor, numberOfLines: Int, textAlignment: NSTextAlignment, font: UIFont) {
        messageLabel.frame = frame
        messageLabel.text = text
        messageLabel.textColor = textColor
        messageLabel.numberOfLines = numberOfLines
        messageLabel.textAlignment = textAlignment
        messageLabel.font = font
        messageLabel.sizeToFit()
    }

}

extension MenuViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lessonsData.count != 0 {
            self.expandTableView.backgroundView = UILabel()
            return lessonsData.count
        } else {
            let messageLabel: UILabel = UILabel()
            setMessageLabel(messageLabel, frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height), text: "No data is currently available.", textColor: UIColor.black, numberOfLines: 0, textAlignment: NSTextAlignment.center, font: UIFont(name:"Palatino-Italic", size: 20)!)
            self.expandTableView.backgroundView = messageLabel
            self.expandTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        cell.imageVIewCell.image = UIImage(named: "Inspiration-01")
        cell.labelCell.text = lessonsData[indexPath.row].title
        print(lessonsData[indexPath.row].title)
        
        // MARK: progressView
//        let progressView = UIProgressView(progressViewStyle: .default)
//        //setting height of progressView
//        progressView.frame = CGRect(x: 230, y: 20, width: 130, height: 130)
//        progressView.progress += 0.5
//        progressView.rightAnchor.accessibilityActivate()
//        //**//inserisci valore formazione
//        progressView.setProgress(Float(0.5), animated: true)
//        progressView.progressTintColor = UIColor.red
//        cell.textLabel?.text = "Formazione: \(45)%"
//        cell.contentView.addSubview(progressView)
        
        return cell
    }
}

extension MenuViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
    }
    
}
