//
//  LessonViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 2/19/19.
//  Copyright © 2019 UIB. All rights reserved.
//

import UIKit
import Alamofire

protocol PassLessonTaskResult {
    func setResult(result: Int, topicId: Int)
}

class BBCLessonViewController: UIViewController, PassLessonTaskResult {
    
    @IBOutlet weak var mSegment: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var miniPlayer:MiniPlayerViewController?
    var currentSong: Song?
    
    var nowPlayingImageView: UIImageView!
    
    var lessonId: String?
    var titleMusic: String?
    var imageUrl: String?
    var audioUrl: String?
    
    private var isTranscriptFinished = false
    private var isVocabularyFinished = false
    
    lazy var vocabularyController: EditableListViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "editableView") as! EditableListViewController
        viewController.lessonId = lessonId
        viewController.taskId = 0
        viewController.delegate = self
        return viewController
    }()
    
    lazy var finishVocabularyController: FinishViewController = {
        let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "finishVC") as! FinishViewController
        addViewControllerAsChildViewController(childViewController: viewController)
        return viewController
    }()
    
    lazy var finishTranscriptController: FinishViewController = {
        let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "finishVC") as! FinishViewController
        addViewControllerAsChildViewController(childViewController: viewController)
        return viewController
    }()
    
    lazy var transcriptController: EditableListViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "editableView") as! EditableListViewController
        viewController.lessonId = lessonId
        viewController.taskId = 1
        viewController.delegate = self
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNowPlayingAnimation()
        getLessonById()
        
        
    }
    
    func createNowPlayingAnimation() {
        
        // Setup ImageView
        nowPlayingImageView = UIImageView(image: UIImage(named: "NowPlayingBars-3"))
        nowPlayingImageView.autoresizingMask = []
        nowPlayingImageView.contentMode = UIView.ContentMode.center
        
        // Create Animation
        nowPlayingImageView.animationImages = AnimationFrames.createFrames()
        nowPlayingImageView.animationDuration = 0.7
        
        // Create Top BarButton
        let barButton = UIButton(type: .custom)
        barButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        barButton.addSubview(nowPlayingImageView)
        nowPlayingImageView.center = barButton.center
        
        let barItem = UIBarButtonItem(customView: barButton)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    func startNowPlayingAnimation(_ animate: Bool) {
        animate ? nowPlayingImageView.startAnimating() : nowPlayingImageView.stopAnimating()
    }
    
    private func getLessonById(){
        showHUD("Process")
        Alamofire.request("http://de.uib.kz/post/get_bbc.php",
                          method: .post,
                          parameters: ["lesson_id": lessonId!])
            .responseBBCLessonModel { response in
                if let mLessonModel = response.result.value {
                    if mLessonModel.status==1{
                        // set audio here
                        if (mLessonModel.transcript?.count)!>0{
                            self.transcriptController.allTask = mLessonModel.transcript!
                            self.addViewControllerAsChildViewController(childViewController: self.transcriptController)
                        }
                        if (mLessonModel.vocabulary?.count)!>0{
                            self.vocabularyController.allTask = mLessonModel.vocabulary!
                            self.addViewControllerAsChildViewController(childViewController: self.vocabularyController)
                        }
                        self.audioUrl = mLessonModel.audioURL
                        self.setupView()
                    }
                }
                self.hideHUD()
        }
    }
    
    private func setupView(){
        setupSegmentedControl()
        updateView()
        setupMiniPlayer()
    }
    
    private func setupMiniPlayer(){
        currentSong = Song(title: titleMusic!, duration: 123, artist: "Divid Bowe",  mediaURL: URL(string: imageUrl!),coverArtURL: URL(string: audioUrl!))
        miniPlayer?.configure(song: currentSong)
    }
    
    private func setupSegmentedControl(){
        mSegment.removeAllSegments()
        mSegment.insertSegment(withTitle: "Vocabulary", at: 0, animated: false)
        mSegment.insertSegment(withTitle: "Transcript", at: 1, animated: false)
        mSegment.addTarget(self, action: #selector(selectionDidChanged(sender:)), for: .valueChanged)
        mSegment.selectedSegmentIndex = 0
    }
    
    private func updateView(){
        if isVocabularyFinished{
            finishVocabularyController.view.isHidden = !(mSegment.selectedSegmentIndex==0)
        }
        else{
            vocabularyController.view.isHidden = !(mSegment.selectedSegmentIndex==0)
        }
        if isTranscriptFinished {
            finishTranscriptController.view.isHidden = mSegment.selectedSegmentIndex==0
        }
        else{
            transcriptController.view.isHidden = mSegment.selectedSegmentIndex==0
        }
    }
    
    @objc func selectionDidChanged(sender: UISegmentedControl){
        updateView()
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
        print(topicId)
        if topicId == 0 {
            isVocabularyFinished = true
            finishVocabularyController.progress = result
            removeViewControllerAsChildViewController(childViewController: vocabularyController)
        }
        else{
            isTranscriptFinished = true
            finishTranscriptController.progress = result
            removeViewControllerAsChildViewController(childViewController: transcriptController)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MiniPlayerViewController {
            miniPlayer = destination
            miniPlayer?.delegate = self
        }
    }
    
    

}

extension BBCLessonViewController: MiniPlayerDelegate {
    func expandSong(song: Song) {
        //1.
        guard let maxiCard = storyboard?.instantiateViewController(
            withIdentifier: "MaxiSongCardViewController")
            as? MaxiSongCardViewController else {
                assertionFailure("No view controller ID MaxiSongCardViewController in storyboard")
                return
        }
        //2.
        maxiCard.backingImage = view.makeSnapshot()
        //3.
        maxiCard.currentSong = song
        
        maxiCard.sourceView = miniPlayer
//        if let tabBar = tabBarController?.tabBar {
//            maxiCard.tabBarImage = tabBar.makeSnapshot()
//        }
        //4.
        present(maxiCard, animated: false)
    }
}
