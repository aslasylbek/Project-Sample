//
//  ResultViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 12/21/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import Alamofire

class ResultViewController: UIViewController, ScrollUISegmentControllerDelegate{

    var allResults = [TopicResult]()
    var exersice = [Exercise]()
    
    
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var segment: UIView!
    
    var refresh: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "NothingFoundCell", bundle: nil)
        resultTableView.register(cellNib, forCellReuseIdentifier: "NothingFound")
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [.foregroundColor: UIColor(named: "accent") ?? .white])
        //refresh.backgroundColor = .black
        refresh.tintColor = UIColor(named: "accent")
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        resultTableView.addSubview(refresh)
        refresh.beginRefreshing()
        handleRefresh()
    }
    
    func selectItemAt(index: Int, onScrollUISegmentController scrollUISegmentController: ScrollUISegmentController) {
        exersice = allResults[index].exercises!
        resultTableView.reloadData()
    }
    
    @objc func handleRefresh()  {
        requestForResults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Results"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if refresh.isRefreshing {
            refresh.endRefreshing()
        }
    }
    
    func addScrollUISegmentController() {
        if self.segment.subviews.count>0{
            self.segment.viewWithTag(2)?.removeFromSuperview()
        }
        var segmentItems = [String]()
        for topic in allResults{
            segmentItems.append(topic.title!)
        }
        let segment = ScrollUISegmentController.init(frame: CGRect(x:5 ,y:5, width: self.segment.frame.width - 5, height: 30), andItems: segmentItems)
        segment.segmentDelegate = self
        segment.tag = 2
        segment.itemWidth = 50
        segment.segmentTintColor = UIColor(named: "accent")!
        self.segment.addSubview(segment)
        segment.selectFirst()
        // Delete
    }
    
    func requestForResults() {
        if Connectivity.isConnectedToInternet{
            guard let courseId = UserDefaults.standard.string(forKey: "course_id") else {
                return
            }
            let userId = UserDefaults.standard.string(forKey: "user_id")
            
            Alamofire.request("http://de.uib.kz/post/get_user_results.php",
                              method: .post,
                              parameters: ["user_id": userId!,
                                           "course_id": courseId])
                .responseResultModel { response in
                    if let resultModel = response.result.value {
                        if (resultModel.topics?.count)!>0{
                            self.allResults = resultModel.topics!
                            self.addScrollUISegmentController()
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.refresh.endRefreshing()
                        self.view.setNeedsDisplay()
                    }
            }
        }
        else{
            Utils.noInternetMessage(controller: self)
            if refresh.isRefreshing{
                refresh.endRefreshing()
            }
        }
    }
    
}

extension ResultViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exersice.isEmpty ? 1 : exersice[section].results!.count
        //return (exersice[section].results?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return exersice.isEmpty ? "No data found" : exersice[section].description
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return exersice.isEmpty ? 1 : exersice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if exersice.isEmpty{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NothingFound", for: indexPath)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell")
            let overall = exersice[indexPath.section].results![indexPath.row].overall
            if Int(overall!)!<0{
                return UITableViewCell()
            }
            cell?.textLabel?.text = overall
            cell?.detailTextLabel?.text = exersice[indexPath.section].results![indexPath.row].date
            return cell!
            
        }
    }
}
