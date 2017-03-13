//
//  ImagePreviewController.swift
//  ServalCat
//
//  Created by 史　翔新 on 2017/03/10.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import UIKit

public class ImagePreviewController: UIViewController {
	
	enum State {
		case normal
		case switchingImage
		case dismissing
	}
	
	fileprivate(set) var state: State = .normal
	
	fileprivate var dismissAction: ((ImagePreviewController) -> Void)?
	
	fileprivate let imageManager: ImageManager
	
	private(set) public lazy var previewView: ImagePreviewView = {
		let view = ImagePreviewView()
		return view
	}()
	
	var currentIndex: Int {
		return self.imageManager.index
	}
	
	public init(images: [UIImage]) {
		
		let imageManager = ImageManager(images: images)
		self.imageManager = imageManager
		
		super.init(nibName: nil, bundle: nil)
		
	}
	
	public convenience init() {
		self.init(images: [])
	}
	
	required public init?(coder aDecoder: NSCoder) {
		self.imageManager = ImageManager(images: [])
		super.init(coder: aDecoder)
	}
	
	public override func loadView() {
		self.previewView.frame = UIScreen.main.bounds
		self.previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.view = self.previewView
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		self.setupButtons()
		self.setupDataSource()
		self.setupGestures()
		self.updateViews()
	}
	
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.previewView.showBars()
	}
	
	private func setupDataSource() {
		self.previewView.dataSource = self.imageManager
	}
	
	private func setupBackButton() {
		self.previewView.setOnBackButtonTappedAction { [weak self] in
			self?.onBackButtonTapped()
		}
	}
	
	private func setupOnImageTappedGesture() {
		
		self.previewView.setOnImageTappedAction { [weak self] (_) in
			self?.previewView.showBars()
		}
		
	}
	
	private func setupOnImagedPannedGesture() {
		
		self.previewView.setOnImagePannedAction { [weak self] (gesture, view) in
			
			switch gesture.state {
			case .began:
				self?.changeState(basedOnTranslation: gesture.translation(in: nil))
				fallthrough
				
			case .changed:
				self?.moveImagePreview(in: view, by: gesture.translation(in: nil))
				
			case .cancelled:
				self?.moveImagePreview(in: view, by: .zero)
				self?.resetState()
				
			case .ended:
				self?.setupImage(in: view, underSpeed: gesture.velocity(in: nil))
				self?.resetState()
				
			case .possible, .failed:
				break
			}
			
		}
		
	}
	
	private func setupButtons() {
		self.setupBackButton()
	}
	
	private func setupGestures() {
		self.setupOnImageTappedGesture()
		self.setupOnImagedPannedGesture()
	}
	
	private func updateViews() {
		self.previewView.updateImages()
	}
	
}

extension ImagePreviewController {
	
	fileprivate func onBackButtonTapped() {
		self.dismissAction?(self)
	}
	
}

extension ImagePreviewController {
	
	private func download() {
		let image = UIImage()
		UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
	}
	
	@objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
		
	}
	
	@objc fileprivate func onDownloadButtonTapped() {
		self.download()
	}
	
}

extension ImagePreviewController {
	
	fileprivate func showBars() {
		self.previewView.showBars()
	}
	
}

extension ImagePreviewController {
	
	private func setToCurrentImage(for view: ImagePreviewView) {
		view.setToCurrentImage(preSwitching: nil)
	}
	
	private func changeToPreviousImage(for view: ImagePreviewView) {
		
		guard self.imageManager.canDecreaseIndex else {
			self.setToCurrentImage(for: view)
			return
		}
		
		view.setToPreviousImage { 
			self.imageManager.decreaseIndex()
		}
		
	}
	
	private func changeToNextImage(for view: ImagePreviewView) {
		
		guard self.imageManager.canIncreaseIndex else {
			self.setToCurrentImage(for: view)
			return
		}
		
		view.setToNextImage { 
			self.imageManager.increaseIndex()
		}
		
	}
	
	private func panImageHorizontally(in view: ImagePreviewView, by translation: CGPoint) {
		
		var translation = CGPoint(x: translation.x, y: 0)
		
		switch translation.x {
		case let x where (x < 0 && !self.imageManager.canIncreaseIndex):
			translation.x *= 0.3
			
		case let x where (x > 0 && !self.imageManager.canDecreaseIndex):
			translation.x *= 0.3
			
		default:
			break
		}
		
		view.setImageViewPosition(withTranslation: translation)
		
	}
	
	fileprivate func panImageVertically(in view: ImagePreviewView, by translation: CGPoint) {
		
		let translation = CGPoint(x: 0, y: translation.y)
		let dismissingProgress = abs(translation.y) / view.bounds.height
		
		view.setImageViewPosition(withTranslation: translation)
		view.setImageDismissingProgress(to: dismissingProgress)
		
	}
	
	fileprivate func changeState(basedOnTranslation translation: CGPoint) {
		
		guard self.state == .normal else {
			return
		}
		
		let horizontal = abs(translation.x)
		let vertical = abs(translation.y)
		
		if horizontal >= vertical {
			self.state = .switchingImage
			
		} else {
			self.state = .dismissing
		}
		
	}
	
	fileprivate func switchImage(in view: ImagePreviewView, underSpeed velocity: CGPoint) {
		
		switch (view.currentImagePosition.x, velocity.x) {
		case let (a, b) where (a > 0 && b < 0) || (a < 0 && b > 0):
			self.setToCurrentImage(for: view)
			
		case let (a, b) where (a < 0 && b < 0):
			self.changeToNextImage(for: view)
			
		case let (a, b) where (a > 0 && b > 0):
			self.changeToPreviousImage(for: view)
			
		case let (a, _) where (a < view.bounds.width * -0.2):
			self.changeToNextImage(for: view)
			
		case let (a, _) where (a > view.bounds.width * 0.2):
			self.changeToPreviousImage(for: view)
			
		default:
			self.setToCurrentImage(for: view)
		}
		
	}
	
	fileprivate func dismissImage(in view: ImagePreviewView, underSpeed velocity: CGPoint) {
		
		switch (view.currentImagePosition.y, velocity.y) {
		case let (a, b) where (a > 0 && b < 0) || (a < 0 && b > 0):
			self.setToCurrentImage(for: view)
			
		case let (a, b) where (a > 0 && b > 0) || (a < 0 && b < 0):
			self.dismissAction?(self)
			
		case let (a, _) where (a < view.bounds.height * -0.2) || (a > view.bounds.height * 0.2):
			self.dismissAction?(self)
			
		default:
			self.setToCurrentImage(for: view)
		}
		
	}
	
	fileprivate func resetState() {
		
		self.state = .normal
		
	}
	
	fileprivate func moveImagePreview(in view: ImagePreviewView, by translation: CGPoint) {
		
		switch self.state {
		case .normal:
			return
			
		case .switchingImage:
			self.panImageHorizontally(in: view, by: translation)
			
		case .dismissing:
			self.panImageVertically(in: view, by: translation)
		}
		
	}
	
	fileprivate func setupImage(in view: ImagePreviewView, underSpeed velocity: CGPoint) {
		
		switch self.state {
		case .normal:
			return
			
		case .switchingImage:
			self.switchImage(in: view, underSpeed: velocity)
			
		case .dismissing:
			self.dismissImage(in: view, underSpeed: velocity)
		}
		
	}
	
}

extension ImagePreviewController {
	
	public func setToolbarButtons(_ buttons: [UIButton]) {
		self.previewView.setButtonsInToolbar(buttons)
	}
	
}

extension ImagePreviewController {
	
	public func setDismissAction(_ action: ((ImagePreviewController) -> Void)?) {
		self.dismissAction = action
	}
	
}

extension ImagePreviewController {
	
	func initialize(imageIndex: Int, initialFrame: CGRect?) {
		self.imageManager.setIndex(to: imageIndex)
		self.previewView.updateImages()
		self.previewView.setCurrentImageFrame(initialFrame)
	}
	
}

extension ImagePreviewController {
	
	func showUpAfterMovedToParentController() {
		self.previewView.setBackgroundAlpha(to: 1)
		self.previewView.setCurrentImageViewAlpha(to: 1)
		self.previewView.showBars()
		self.previewView.placePreviewImages()
		
	}
	
	func hideBeforeRemovingFromParentController(andMoveCurrentImageTo frame: CGRect?) {
		self.previewView.setBackgroundAlpha(to: 0)
		self.previewView.setCurrentImageViewAlpha(to: 0)
		self.previewView.hideBars()
		self.previewView.setCurrentImageFrame(frame)
	}
	
}

extension ImagePreviewController {
	
	func postShowUpProcess() {
		self.previewView.showPreviousAndNextImagePreviewView()
	}
	
	func preHideProcess() {
		self.previewView.hidePreviousAndNextImagePreoviewView()
	}
	
}
