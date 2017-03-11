//
//  ImagePreviewController.swift
//  ServalCat
//
//  Created by 史　翔新 on 2017/03/10.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import UIKit

public class ImagePreviewController: UIViewController {
	
	fileprivate var dismissAction: (() -> Void)?
	
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
	
	deinit {
		print("ImagePreviewController deinit")
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
	
	private func setupDownloadButton() {
		let button = UIButton()
		button.addTarget(self, action: #selector(self.onDownloadButtonTapped), for: .touchUpInside)
		button.setTitle("⬇️", for: .normal)
		self.previewView.setButtonsInToolbar([button])
	}
	
	private func setupOnImageTappedGesture() {
		self.previewView.setOnImageTappedAction { [weak self] (_) in
			self?.previewView.showBars()
		}
	}
	
	private func setupOnImagedPannedGesture() {
		self.previewView.setOnImagePannedAction { (translation, view) in
			print(translation)
			view.frame.origin += translation
		}
	}
	
	private func setupButtons() {
		self.setupBackButton()
		self.setupDownloadButton()
	}
	
	private func setupGestures() {
		self.setupOnImageTappedGesture()
		self.setupOnImagedPannedGesture()
	}
	
	private func updateViews() {
		self.previewView.updateImage()
	}
	
}

extension ImagePreviewController {
	
	fileprivate func onBackButtonTapped() {
		self.dismissAction?()
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
	
	public func setDismissAction(_ action: (() -> Void)?) {
		self.dismissAction = action
	}
	
}

extension ImagePreviewController {
	
	func showUpAfterMovedToParentController(withImageAt index: Int) {
		self.imageManager.setIndex(to: index)
		self.previewView.setBackgroundAlpha(to: 1)
		self.previewView.showBars()
		self.previewView.updateImage()
	}
	
	func hideBeforeRemovingFromParentController() {
		self.previewView.setBackgroundAlpha(to: 0)
		self.previewView.hideBars()
	}
	
}

private func += (lhs: inout CGPoint, rhs: CGPoint) {
	lhs = CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
