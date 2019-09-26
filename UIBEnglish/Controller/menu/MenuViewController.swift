//
//  MenuViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/14/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import ProgressHUD
import Alamofire
import SwiftyJSON

class MenuViewController: UIViewController {

    @IBOutlet weak var expandTableView: UITableView!
    var lessonsData = [Topic]()
    var refresh: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "NothingFoundCell", bundle: nil)
        expandTableView.register(cellNib, forCellReuseIdentifier: "NothingFound")
        
        
        expandTableView.estimatedRowHeight = 30
        expandTableView.rowHeight = 90
        
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [.foregroundColor: UIColor(named: "accent") ?? .white])
        //refresh.backgroundColor = .black
        refresh.tintColor = UIColor(named: "accent")
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        expandTableView.addSubview(refresh)
        
      
    }
    
    @objc func handleRefresh()  {
        //check for reload
        getUserEnglishData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refresh.endRefreshing()
            self.view.setNeedsDisplay()
        }
        
//        let indexPathNewRow = IndexPath(row: lessonsData.count-1, section: 0)
//        expandTableView.insertRows(at: [indexPathNewRow], with: .automatic)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Menu"
        refresh.beginRefreshing()
        handleRefresh()
        //getUserEnglishData()
        expandTableView.setNeedsDisplay()
    }
    
    private func getUserEnglishData(){
        let url = URL(string: "http://moodle.uib.kz/mobile_eng/data.php")
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        
        print(user_id)
        
        Alamofire.request(url!,
                          method: .post,
                          parameters: ["user_id": user_id!]).responseEnglishModel { response in
            if let englishData = response.result.value {
                guard let english = englishData.english,
                    english.count>0 else {
                        return
                }
                let topics = english[0].topics
                self.lessonsData = topics!
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(english[0].courseID!, forKey: "course_id")
                userDefaults.setValue(englishData.info![0].fio!, forKey: "student_name")
                userDefaults.setValue(englishData.info![0].group!, forKey: "student_group")
                userDefaults.setValue(englishData.info![0].program!, forKey: "student_program")
                if englishData.info![0].code! != "0" && englishData.info![0].code != nil {
                    userDefaults.setValue(englishData.info![0].code!, forKey: "student_code")
                }
                userDefaults.setValue(english[0].teacherFio!, forKey: "teacher_name")
                userDefaults.setValue(english[0].dispName!, forKey: "disc_name")
                userDefaults.synchronize()
                DispatchQueue.main.async {
                    self.expandTableView.reloadData()
                }
            }
            else{
            }
        }
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
}

extension MenuViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonsData.isEmpty ? 1 : lessonsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if lessonsData.isEmpty{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NothingFound", for: indexPath)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel!.text = lessonsData[indexPath.row].title
            return cell
        }
        
        
        
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
        
    }
}

extension MenuViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
    }
    
}
