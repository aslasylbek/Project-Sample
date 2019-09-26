//
//  BBCViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 2/19/19.
//  Copyright © 2019 UIB. All rights reserved.
//

import UIKit
import Alamofire

class BBCViewController: UIViewController, ScrollUISegmentControllerDelegate, UIScrollViewDelegate {
    

    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mLevel: UILabel!
    @IBOutlet weak var mLevelDescription: UITextView!
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mSegment: UIView!
    
    
    var allLessons = [Lesson]()
    var allCategory = [Category]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView.estimatedRowHeight = 70.0
        mTableView.rowHeight = UITableView.automaticDimension
        getBBCCategories()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "BBC English"
    }
    
    func updateUI(category: Category) {
        mLevel.text = category.level
        mLevelDescription.text = category.description
    }
    
    func addScrollUISegmentController() {
        if mSegment.subviews.count>0{
            mSegment.viewWithTag(2)?.removeFromSuperview()
        }
        var segmentItems = [String]()
        for category in allCategory{
            segmentItems.append(category.title!)
        }
        let segment = ScrollUISegmentController.init(frame: CGRect(x:5 ,y:5, width: mSegment.frame.width - 5, height: 30), andItems: segmentItems)
        segment.segmentDelegate = self
        segment.tag = 2
        segment.itemWidth = 50
        segment.segmentTintColor = UIColor(named: "accent")!
        mSegment.addSubview(segment)
        segment.selectFirst()
    }
    
    func selectItemAt(index: Int, onScrollUISegmentController scrollUISegmentController: ScrollUISegmentController) {
        updateUI(category: allCategory[index])
        getBBCLessons(id: allCategory[index].id!)
    }
    
    func getBBCCategories() {
        showHUD("Process")
        Alamofire.request("http://de.uib.kz/post/get_bbc.php",
                          method: .post,
                          parameters: ["all": 1])
            .responseBBCCategoryModel { response in
                if let mCategoryModel = response.result.value {
                    if mCategoryModel.status==1{
                        if (mCategoryModel.categories?.count)!>0{
                            self.allCategory = mCategoryModel.categories!
                            self.addScrollUISegmentController()
                        }
                    }
                }
                self.hideHUD()
        }
    }
    
    func getBBCLessons(id: String) {
        showHUD("Process")
        Alamofire.request("http://de.uib.kz/post/get_bbc.php",
                          method: .post,
                          parameters: ["category_id": id])
            .responseBBCListModel { response in
                if let mLessonModel = response.result.value {
                    if mLessonModel.status==1{
                        self.allLessons = mLessonModel.lessons!
                        self.mTableView.reloadData()
                    }
                }
                self.hideHUD()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goLesson" {
            if let controller = segue.destination as? BBCLessonViewController {
                let lesson = allLessons[(mTableView.indexPathsForSelectedRows?.first?.row)!]
                controller.lessonId = lesson.id
                controller.titleMusic = lesson.title
                
                controller.imageUrl = lesson.img
            }
        }
    }
}

extension BBCViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bbcCell", for: indexPath) as! BBCTableViewCell
        cell.mTitle.text = allLessons[indexPath.row].title
        cell.mDescription.text = allLessons[indexPath.row].description
        if let strUrl = allLessons[indexPath.row].img, let imgUrl = URL(string: strUrl) {
            cell.mImage.loadImageWithUrl(imgUrl)
        }
        return cell
    }
}
