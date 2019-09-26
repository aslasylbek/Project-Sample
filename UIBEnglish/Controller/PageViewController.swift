//
//  PageViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/27/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit
import Alamofire

struct ConstantsVCTitle {
    static let rememberVC = "rememberVC"
    static let vocTestVC = "vocTestVC"
    static let finishVC = "finishVC"
    static let grammarVC = "grammarVC"
    static let readingVC = "readingRouter"
    static let listeningVC = "listeningVC"
}

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, AddSegmentProtocol {
    
    var topicId: String?
    var taskId: Int?
    var viewControllerList: [UIViewController] = []
    var counter = 0
    var readingData: ReadingModel?
    private var rvc: ReadingSegmentController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch taskId {
        case 0:
            let v = pageViewController(identifier: ConstantsVCTitle.rememberVC, taskId: taskId!)
            let vc2 = pageViewController(identifier: ConstantsVCTitle.vocTestVC, taskId: taskId!)
            viewControllerList.append(v)
            viewControllerList.append(vc2)
        case 4:
            let listeningVC = pageViewController(identifier: ConstantsVCTitle.listeningVC, taskId: taskId!)
            viewControllerList.append(listeningVC)
        case 5:
            let readingVC = pageViewController(identifier: ConstantsVCTitle.readingVC, taskId: taskId!)
            viewControllerList.append(readingVC)
        case 6:
            let grammarVC = pageViewController(identifier: ConstantsVCTitle.grammarVC, taskId: 1)
            viewControllerList.append(grammarVC)
        default:
            let vocTaskVC = pageViewController(identifier: ConstantsVCTitle.vocTestVC, taskId: taskId!)
            viewControllerList.append(vocTaskVC)
            break
        }
        self.delegate = self
        setViewControllers([self.viewControllerList.first!], direction: .forward, animated: true) { (bool) in
            self.counter+=1
        }
    }
    
    //MARK: refactor this boilerplate code) one case to divide pageViewController for any submenu
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        let previousIndex = vcIndex - 1
        guard previousIndex>=0 else {return nil}
        guard viewControllerList.count > previousIndex else {return nil}
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        let nextIndex = vcIndex+1
        guard viewControllerList.count != nextIndex else{return nil}
        return viewControllerList[nextIndex]
    }
    
    func pageViewController(identifier: String, taskId: Int) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)

        switch identifier {
        case ConstantsVCTitle.grammarVC:
            let gvc = vc as? GrammarViewController
            gvc?.topicId = topicId
            gvc?.taskId = taskId
            gvc?.delegate = self
        case ConstantsVCTitle.rememberVC:
            let vcv = vc as? VocabularyViewController
            vcv?.topicId = topicId
            vcv?.delegate = self
        case ConstantsVCTitle.vocTestVC:
            let vcv = vc as? VocTestViewController
            vcv?.delegate = self
            vcv?.topicId = topicId
            vcv?.taskId = taskId
        case ConstantsVCTitle.readingVC:
            rvc = vc as? ReadingSegmentController
            rvc?.topicId = topicId
            rvc?.delegate = self
        case ConstantsVCTitle.listeningVC:
            let lvc = vc as? ListeningViewController
            lvc?.delegate = self
            lvc?.topicId = topicId
        default: break
        }
        
        return vc
    }
    
    func addSegment() {
        addSegmentControl()
    }
    
    private func addSegmentControl(){
        let items = ["Article" , "Tasks"]
        let segmentedControl = UISegmentedControl(items : items)
        segmentedControl.center = (self.navigationController?.navigationBar.center)!
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(PageViewController.indexChanged(segment:)), for: .valueChanged)
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.backgroundColor = .white
        segmentedControl.tintColor = UIColor(named: "accent")
        self.navigationItem.titleView = segmentedControl
    }
    
    @objc func indexChanged( segment : UISegmentedControl){
        rvc?.listenerSegment(index: segment.selectedSegmentIndex)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
   

}

extension PageViewController:  PassVocabulatyResultToParent{
    

    
    func passResult(result: Int) {
        let finishVC = pageViewController(identifier: ConstantsVCTitle.finishVC, taskId: 0) as? FinishViewController
        finishVC?.progress = result
        viewControllerList.append(finishVC!)
        self.setViewControllers([self.viewControllerList[counter]], direction: .forward, animated: true, completion: nil)
        counter+=1
    }
    
    func notifyParent(status: Int) {
        self.setViewControllers([self.viewControllerList[counter]], direction: .forward, animated: true, completion: nil)
        counter+=1
        
    }
    
}


