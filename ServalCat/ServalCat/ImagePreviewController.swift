//
//  ImagePreviewController.swift
//  ImagePreviewer
//
//  Created by 史　翔新 on 2017/03/10.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import UIKit

public protocol ImagePreviewControllerPreDismissDelegate: class {
	func imagePreviewController(_ controller: ImagePreviewController, willDismissFrom view: UIImageView, at index: Int)
}

public class ImagePreviewController: UIViewController {
	
	weak var preDismissDelegate: ImagePreviewControllerPreDismissDelegate?
	
	fileprivate var dismissAction: (() -> Void)?
	
	fileprivate let imageManager: ImageManager
	
	private(set) public lazy var previewView: ImagePreviewView = {
		let view = ImagePreviewView()
		return view
	}()
	
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
		self.view = self.previewView
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		self.setupButtons()
		self.setupDataSource()
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
	
	private func setupButtons() {
		self.setupBackButton()
		self.setupDownloadButton()
	}
	
	private func updateViews() {
		self.previewView.updateImages()
	}
	
}

extension ImagePreviewController {
	
	fileprivate func onBackButtonTapped() {
		let imageView = UIImageView()
		self.parent?.view.addSubview(imageView)
		UIView.animate(withDuration: 0.2, animations: {
			self.preDismissDelegate?.imagePreviewController(self, willDismissFrom: imageView, at: 0)
			
		}) { _ in
			imageView.removeFromSuperview()
			self.dismissAction?() ?? self.dismiss(animated: true, completion: nil)
		}
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
	
	func setDismissAction(_ action: (() -> Void)?) {
		self.dismissAction = action
	}
	
}
