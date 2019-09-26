//
//  ReadingSegmentController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 4/16/19.
//  Copyright © 2019 UIB. All rights reserved.
//

import UIKit
import Alamofire

protocol AddSegmentProtocol {
    func addSegment()
}

class ReadingSegmentController: UIViewController, PassVocabulatyResultToParent {
  
    @IBOutlet weak var containerView: UIView!
    
    var topicId: String?
    
    var delegate: AddSegmentProtocol!
    
    private var isTranscriptFinished = false
    
    var readingController: ReadingViewController?
    
    lazy var finishTaskController: FinishViewController = {
        let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "finishVC") as! FinishViewController
        addViewControllerAsChildViewController(childViewController: viewController)
        return viewController
    }()
    
    var readingTaskController: ReadingTaskViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestForReading()
        //setupView()
    }
    
    func requestForReading() {
        showHUD("Process")
        let params = ["topic_id": topicId!] as [String : Any]
        Alamofire.request("http://de.uib.kz/post/get_reading.php",
                          method: .post,
                          parameters: params)
            .responseReadingModel { response in
                if let value = response.result.value{
                    self.readingController = {
                        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "readingVC") as! ReadingViewController
                        viewController.readingData = value[0]
                        viewController.topicId = self.topicId
                        self.addViewControllerAsChildViewController(childViewController: viewController)
                        return viewController
                    }()
                    if (value[0].questionanswer?.count)!>0 || (value[0].truefalse?.count)!>0{
                        self.readingTaskController = {
                            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let viewController = storyboard.instantiateViewController(withIdentifier: "readingTaskVC") as! ReadingTaskViewController
                            viewController.allReading = value[0]
                            viewController.delegate = self
                            viewController.topicId = self.topicId
                            self.addViewControllerAsChildViewController(childViewController: viewController)
                            return viewController
                        }()
                        self.setupView()
                        self.delegate.addSegment()
                    }
                    if (value[0].questionanswer?.count)!>0 {
                        // call protocol
                    }
                }
                else{
                    
                }
                self.hideHUD()
        }
    }
    
    func passResult(result: Int) {
        setResult(result: result, topicId: Int(topicId!)!)
    }
    
    func notifyParent(status: Int) {
        // do nothing
    }
    

    
    private func setupView(){
        updateView(i: 0)
    }
    
    func listenerSegment(index: Int){
        updateView(i: index)
    }
    
    private func updateView(i: Int){
        readingController!.view.isHidden = !(i==0)
        if isTranscriptFinished {
            finishTaskController.view.isHidden = i==0
        }
        else{
            readingTaskController!.view.isHidden = i==0
        }
    }
    
    
    private func addViewControllerAsChildViewController(childViewController: UIViewController){
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParent: self)
    }
    
    private func removeViewControllerAsChildViewController(childViewController: UIViewController){
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
    
    //do remove
    func setResult(result: Int, topicId: Int) {
        
            isTranscriptFinished = true
            finishTaskController.progress = result
            removeViewControllerAsChildViewController(childViewController: readingTaskController!)
        
    }
    

}
