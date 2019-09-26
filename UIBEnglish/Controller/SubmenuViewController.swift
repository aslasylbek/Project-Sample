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
    var startTime: Int?
    var endTime: Int?
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
                title: "Task 1",
                icon: "vocabulary",
                description: "Listen to the phrase and find it on the list.",
                startTime: 0,
                endTime: 0,
                topic_id: lessonData!.topicID!))
            categoryData.append(TaskCategory(
                id: 1,
                title: "Task 2",
                icon: "vocabulary",
                description: "Listen to the phrase and find its translation.",
                startTime: convertToTime(lessonData!.startVoc!) ,
                endTime: convertToTime(lessonData!.endVoc!),
                topic_id: lessonData!.topicID!))
            categoryData.append(TaskCategory(
                id: 2,
                title: "Task 3",
                icon: "vocabulary",
                description: "Read the phrase and find its translation.",
                startTime: convertToTime(lessonData!.startVoc!) ,
                endTime: convertToTime(lessonData!.endVoc!),
                topic_id: lessonData!.topicID!))
            categoryData.append(TaskCategory(
                id: 3,
                title: "Task 4",
                icon: "vocabulary",
                description: "Write the phrase at dictation.",
                startTime: convertToTime(lessonData!.startVoc!) ,
                endTime: convertToTime(lessonData!.endVoc!),
                topic_id: lessonData!.topicID!))
        }
        if (lessonData?.listening?.count)!>0{
            categoryData.append(TaskCategory(
                id: 4,
                title: "Listening",
                icon: "listening",
                description: "Listen to the text and put the missed word.",
                startTime: convertToTime(lessonData!.startListen!) ,
                endTime: convertToTime(lessonData!.endListen!),
                topic_id: lessonData!.topicID!))
        }
        if (lessonData?.reading?.count)!>0{
            categoryData.append(TaskCategory(
                id: 5,
                title: "Reading",
                icon: "reading",
                description: "Read the text and do tasks.",
                startTime: convertToTime(lessonData!.startRead!),
                endTime: convertToTime(lessonData!.endRead!),
                topic_id: lessonData!.topicID!))
        }
        if (lessonData?.grammar![0].constructor?.count)!>0||(lessonData?.grammar![0].missword?.count)!>0{
            categoryData.append(TaskCategory(
                id: 6,
                title: "Grammar",
                icon: "grammar",
                description: "Put the missing word. Building a proposal.",
                startTime: convertToTime(lessonData!.startGram!),
                endTime: convertToTime(lessonData!.endGram!),
                topic_id: lessonData!.topicID!))
        }
        
    }
    
    func convertToTime(_ jsonAny: JSONAny) -> Int? {
        let stringToInt = jsonAny.value as? Int64 ?? 0
        let s = Int(stringToInt)
        print(s)
        return s
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
    
    
    @IBAction func backToMenu(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
        
        let s = collectionView.cellForItem(at: indexPath) as! SubmenuLayout
        if !s.lockedView.isHidden {
            var duration = ""
            if (s.submenu?.startTime)! > 0{
                duration.append(Utils.getDateFromTimeStamp(timeStamp: (s.submenu?.startTime)!))
            }
            duration.append("  ")
            if (s.submenu?.endTime)! > 0{
                duration.append(Utils.getDateFromTimeStamp(timeStamp: (s.submenu?.endTime)!))
            }
            let alertController = UIAlertController(
                title: "Locked",
                message: "Available in: \(duration)", 
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        else{
            performSegue(withIdentifier: "goTest", sender: s.submenu)
        }
    }
    
    
}

