//
//  SubmenuViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/26/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit

struct TaskCategory {
    var id: Int
    var title: String
    var icon: String
    var description: String
    var startTime: EndGram
    var endTime: EndGram
    var topic_id: String
}

class SubmenuViewController: UIViewController {

    var lessonData: Topic?
    var categoryData = [TaskCategory]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        title = lessonData?.title
        
        if (lessonData?.words?.count)! > 0{
            categoryData.append(TaskCategory(
                id: 0,
                title: "Task1",
                icon: "right-arrow",
                description: "This is desc",
                startTime: lessonData!.startVoc! ,
                endTime: lessonData!.endVoc!,
                topic_id: lessonData!.topicID!))
            categoryData.append(TaskCategory(
                id: 1,
                title: "Task2",
                icon: "right-arrow",
                description: "This is desc",
                startTime: lessonData!.startVoc! ,
                endTime: lessonData!.endVoc!,
                topic_id: lessonData!.topicID!))
            categoryData.append(TaskCategory(
                id: 2,
                title: "Task3",
                icon: "right-arrow",
                description: "This is desc",
                startTime: lessonData!.startVoc! ,
                endTime: lessonData!.endVoc!,
                topic_id: lessonData!.topicID!))
            categoryData.append(TaskCategory(
                id: 3,
                title: "Task4",
                icon: "right-arrow",
                description: "This is desc",
                startTime: lessonData!.startVoc! ,
                endTime: lessonData!.endVoc!,
                topic_id: lessonData!.topicID!))
        }
        if (lessonData?.listening?.count)!>0{
            categoryData.append(TaskCategory(
                id: 4,
                title: "Listening",
                icon: "right-arrow",
                description: "This is desc",
                startTime: lessonData!.startListen! ,
                endTime: lessonData!.endListen!,
                topic_id: lessonData!.topicID!))
        }
        if (lessonData?.reading?.count)!>0{
            categoryData.append(TaskCategory(
                id: 5,
                title: "Reading",
                icon: "right-arrow",
                description: "This is desc",
                startTime: lessonData!.startRead!,
                endTime: lessonData!.endRead!,
                topic_id: lessonData!.topicID!))
        }
        if (lessonData?.grammar?.count)!>0{
            categoryData.append(TaskCategory(
                id: 6,
                title: "Grammar",
                icon: "right-arrow",
                description: "This is desc",
                startTime: lessonData!.startGram! ,
                endTime: lessonData!.endGram!,
                topic_id: lessonData!.topicID!))
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goTest" {
            if let controller = segue.destination as? PageViewController {
                controller.topicId = lessonData?.topicID
                let category = categoryData[(collectionView.indexPathsForSelectedItems?.first!.row)!]
                controller.taskId = category.id
            }
        }
    }
    
    
}

extension SubmenuViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellS", for: indexPath) as? SubmenuLayout{
            
            itemCell.submenu = categoryData[indexPath.row]
            
            return itemCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let word = lessonData?.words![indexPath.row]
    }
    
    
}

