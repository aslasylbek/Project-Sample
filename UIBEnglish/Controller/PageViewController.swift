//
//  PageViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11/27/18.
//  Copyright © 2018 UIB. All rights reserved.
//

import UIKit

struct ConstantsVCTitle {
    static let rememberVC = "rememberVC"
    static let vocTestVC = "vocTestVC"
    static let finishVC = "finishVC"
}

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var topicId: String?
    var taskId: Int?
    var viewControllerList: [UIViewController] = []
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TopicId\(topicId)")
        let v = pageViewController(identifier: ConstantsVCTitle.rememberVC)
        let vc2 = pageViewController(identifier: ConstantsVCTitle.vocTestVC)
        viewControllerList.append(v)
        viewControllerList.append(vc2)
        self.delegate = self
        setViewControllers([self.viewControllerList.first!], direction: .forward, animated: true) { (bool) in
            self.counter+=1
        }
    }
    
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
    
    func pageViewController(identifier: String) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)

        switch identifier {
        case ConstantsVCTitle.rememberVC:
            let rcv = vc as? VocabularyViewController
            rcv?.topicId = topicId
            rcv?.delegate = self
        case ConstantsVCTitle.vocTestVC:
            let vcv = vc as? VocTestViewController
            vcv?.delegate = self
            vcv?.topicId = topicId
            vcv?.taskId = taskId
        default: break
        }
        
        return vc
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

}

extension PageViewController: NotifyParentPageView, PassVocabulatyResultToParent{
    func passResult(result: Int) {
        let finishVC = pageViewController(identifier: ConstantsVCTitle.finishVC)
        viewControllerList.append(finishVC)
        self.setViewControllers([self.viewControllerList[counter]], direction: .forward, animated: true, completion: nil)
        counter+=1
    }
    
    func notifyParent(status: Int) {
        self.setViewControllers([self.viewControllerList[counter]], direction: .forward, animated: true, completion: nil)
        counter+=1
    }
    
}


