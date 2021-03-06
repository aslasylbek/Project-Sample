//
//  MaxiSongCardViewController.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 3/12/19.
//  Copyright © 2019 UIB. All rights reserved.
//


import UIKit



class MaxiSongCardViewController: UIViewController, SongSubscriber {
    
    var subDelegate: NowPlayingViewControllerDelegate!
    //cover image constraints
    @IBOutlet weak var coverImageContainerTopInset: NSLayoutConstraint!
    // MARK: - Properties
    let cardCornerRadius: CGFloat = 10
    var delegate: NowPlayingViewControllerDelegate!
    var currentSong: Song?
    
    weak var sourceView: MaxiPlayerSourceProtocol!
    
    let primaryDuration = 0.2 //set to 0.5 when ready
    let backingImageEdgeInset: CGFloat = 15.0
    
    
    //cover image constraints
    @IBOutlet weak var coverImageLeading: NSLayoutConstraint!
    @IBOutlet weak var coverImageTop: NSLayoutConstraint!
    @IBOutlet weak var coverImageBottom: NSLayoutConstraint!
    @IBOutlet weak var coverImageHeight: NSLayoutConstraint!
    
    //scroller
    @IBOutlet weak var scrollView: UIScrollView!
    //this gets colored white to hide the background.
    //It has no height so doesnt contribute to the scrollview content
    @IBOutlet weak var stretchySkirt: UIView!
    
    //cover image
    @IBOutlet weak var coverImageContainer: UIView!
    @IBOutlet weak var coverArtImage: UIImageView!
    @IBOutlet weak var dismissChevron: UIButton!
    //add cover image constraints here
    
    //fake tabbar contraints
    var tabBarImage: UIImage?
    @IBOutlet weak var bottomSectionHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomSectionLowerConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSectionImageView: UIImageView!
    
    //backing image
    var backingImage: UIImage?
    @IBOutlet weak var backingImageView: UIImageView!
    @IBOutlet weak var dimmerLayer: UIView!
    //add backing image constraints here
    
    //add backing image constraints here
    @IBOutlet weak var backingImageTopInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageLeadingInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageTrailingInset: NSLayoutConstraint!
    @IBOutlet weak var backingImageBottomInset: NSLayoutConstraint!
    
    
    //lower module constraints
    @IBOutlet weak var lowerModuleTopConstraint: NSLayoutConstraint!
    
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        modalPresentationCapturesStatusBarAppearance = true //allow this VC to control the status bar appearance
        modalPresentationStyle = .overFullScreen //dont dismiss the presenting view controller when presented
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backingImageView.image = backingImage
        
        scrollView.contentInsetAdjustmentBehavior = .never //dont let Safe Area insets affect the scroll view
        
        coverImageContainer.layer.cornerRadius = cardCornerRadius
        coverImageContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureImageLayerInStartPosition()
        stretchySkirt.backgroundColor = .white //from starter project, this hides the gap
        configureLowerModuleInStartPosition()
        
        
        coverArtImage.image = sourceView.originatingCoverImageView.image
        configureCoverImageInStartPosition()
        configureBottomSection()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SongSubscriber {
            destination.currentSong = currentSong
            destination.subDelegate = delegate
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBackingImageIn()
        animateImageLayerIn()
        animateCoverImageIn()
        animateLowerModuleIn()
        animateBottomSectionOut()
    }
    
    @IBAction func swipeMaxiGesture(_ sender: UISwipeGestureRecognizer) {
        print("lslsl")
        if sender.state == .ended{
            if sender.direction == .down{
                animateBackingImageOut()
                animateCoverImageOut()
                animateLowerModuleOut()
                animateBottomSectionIn()
                animateImageLayerOut() { _ in
                    self.dismiss(animated: false)
                }
            }
        }
    }
}

// MARK: - IBActions
extension MaxiSongCardViewController {
    
    @IBAction func dismissAction(_ sender: Any) {
        animateBackingImageOut()
        animateCoverImageOut()
        animateLowerModuleOut()
        animateBottomSectionIn()
        animateImageLayerOut() { _ in
            self.dismiss(animated: false)
        }
    }
}

//background image animation
extension MaxiSongCardViewController {
    
    //1.
    private func configureBackingImageInPosition(presenting: Bool) {
        let edgeInset: CGFloat = presenting ? backingImageEdgeInset : 0
        let dimmerAlpha: CGFloat = presenting ? 0.3 : 0
        let cornerRadius: CGFloat = presenting ? cardCornerRadius : 0
        
        backingImageLeadingInset.constant = edgeInset
        backingImageTrailingInset.constant = edgeInset
        let aspectRatio = backingImageView.frame.height / backingImageView.frame.width
        backingImageTopInset.constant = edgeInset * aspectRatio
        backingImageBottomInset.constant = edgeInset * aspectRatio
        //2.
        dimmerLayer.alpha = dimmerAlpha
        //3.
        backingImageView.layer.cornerRadius = cornerRadius
    }
    
    //4.
    private func animateBackingImage(presenting: Bool) {
        UIView.animate(withDuration: primaryDuration) {
            self.configureBackingImageInPosition(presenting: presenting)
            self.view.layoutIfNeeded() //IMPORTANT!
        }
    }
    
    //5.
    func animateBackingImageIn() {
        animateBackingImage(presenting: true)
    }
    
    func animateBackingImageOut() {
        animateBackingImage(presenting: false)
    }
}

protocol MaxiPlayerSourceProtocol: class {
    var originatingFrameInWindow: CGRect { get }
    var originatingCoverImageView: UIImageView { get }
}

//Image Container animation.
extension MaxiSongCardViewController {
    
    private var startColor: UIColor {
        return UIColor.white.withAlphaComponent(0.3)
    }
    
    private var endColor: UIColor {
        return .white
    }
    
    //1.
    private var imageLayerInsetForOutPosition: CGFloat {
        let imageFrame = view.convert(sourceView.originatingFrameInWindow, to: view)
        let inset = imageFrame.minY - backingImageEdgeInset
        return inset
    }
    
    //2.
    func configureImageLayerInStartPosition() {
        coverImageContainer.backgroundColor = startColor
        let startInset = imageLayerInsetForOutPosition
        dismissChevron.alpha = 0
        coverImageContainer.layer.cornerRadius = 0
        coverImageContainerTopInset.constant = startInset
        view.layoutIfNeeded()
    }
    
    //3.
    func animateImageLayerIn() {
        //4.
        UIView.animate(withDuration: primaryDuration / 4.0) {
            self.coverImageContainer.backgroundColor = self.endColor
        }
        
        //5.
        UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseIn], animations: {
            self.coverImageContainerTopInset.constant = 0
            self.dismissChevron.alpha = 1
            self.coverImageContainer.layer.cornerRadius = self.cardCornerRadius
            self.view.layoutIfNeeded()
        })
    }
    
    //6.
    func animateImageLayerOut(completion: @escaping ((Bool) -> Void)) {
        let endInset = imageLayerInsetForOutPosition
        
        UIView.animate(withDuration: primaryDuration / 4.0,
                       delay: primaryDuration,
                       options: [.curveEaseOut], animations: {
                        self.coverImageContainer.backgroundColor = self.startColor
        }, completion: { finished in
            completion(finished) //fire complete here , because this is the end of the animation
        })
        
        UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseOut], animations: {
            self.coverImageContainerTopInset.constant = endInset
            self.dismissChevron.alpha = 0
            self.coverImageContainer.layer.cornerRadius = 0
            self.view.layoutIfNeeded()
        })
    }
}


//cover image animation
extension MaxiSongCardViewController {
    //1.
    func configureCoverImageInStartPosition() {
        let originatingImageFrame = sourceView.originatingCoverImageView.frame
        coverImageHeight.constant = originatingImageFrame.height
        coverImageLeading.constant = originatingImageFrame.minX
        coverImageTop.constant = originatingImageFrame.minY
        coverImageBottom.constant = originatingImageFrame.minY
    }
    
    //2.
    func animateCoverImageIn() {
        let coverImageEdgeContraint: CGFloat = 30
        let endHeight = coverImageContainer.bounds.width - coverImageEdgeContraint * 2
        UIView.animate(withDuration: primaryDuration, delay: 0, options: [.curveEaseIn], animations:  {
            self.coverImageHeight.constant = endHeight
            self.coverImageLeading.constant = coverImageEdgeContraint
            self.coverImageTop.constant = coverImageEdgeContraint
            self.coverImageBottom.constant = coverImageEdgeContraint
            self.view.layoutIfNeeded()
        })
    }
    
    //3.
    func animateCoverImageOut() {
        UIView.animate(withDuration: primaryDuration,
                       delay: 0,
                       options: [.curveEaseOut], animations:  {
                        self.configureCoverImageInStartPosition()
                        self.view.layoutIfNeeded()
        })
    }
}

//lower module animation
extension MaxiSongCardViewController {
    
    //1.
    private var lowerModuleInsetForOutPosition: CGFloat {
        let bounds = view.bounds
        let inset = bounds.height - bounds.width
        return inset
    }
    
    //2.
    func configureLowerModuleInStartPosition() {
        lowerModuleTopConstraint.constant = lowerModuleInsetForOutPosition
    }
    
    //3.
    func animateLowerModule(isPresenting: Bool) {
        let topInset = isPresenting ? 0 : lowerModuleInsetForOutPosition
        UIView.animate(withDuration: primaryDuration,
                       delay:0,
                       options: [.curveEaseIn],
                       animations: {
                        self.lowerModuleTopConstraint.constant = topInset
                        self.view.layoutIfNeeded()
        })
    }
    
    //4.
    func animateLowerModuleOut() {
        animateLowerModule(isPresenting: false)
    }
    
    //5.
    func animateLowerModuleIn() {
        animateLowerModule(isPresenting: true)
    }
}

//fake tab bar animation
extension MaxiSongCardViewController {
    //1.
    func configureBottomSection() {
        if let image = tabBarImage {
            bottomSectionHeight.constant = image.size.height
            bottomSectionImageView.image = image
        } else {
            bottomSectionHeight.constant = 0
        }
        view.layoutIfNeeded()
    }
    
    //2.
    func animateBottomSectionOut() {
        if let image = tabBarImage {
            UIView.animate(withDuration: primaryDuration / 2.0) {
                self.bottomSectionLowerConstraint.constant = -image.size.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //3.
    func animateBottomSectionIn() {
        if tabBarImage != nil {
            UIView.animate(withDuration: primaryDuration / 2.0) {
                self.bottomSectionLowerConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
}

