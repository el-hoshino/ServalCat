//
//  ImagePreviewView.swift
//  ServalCat
//
//  Created by 史　翔新 on 2017/03/10.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import UIKit

protocol ImagePreviewViewDataSource: class {
	func getImage(for imagePreviewView: ImagePreviewView) -> UIImage?
	func getNextImage(for imagePreviewView: ImagePreviewView) -> UIImage?
	func getPreviousImage(for imagePreviewView: ImagePreviewView) -> UIImage?
}

public class ImagePreviewView: UIView {
	
	weak var dataSource: ImagePreviewViewDataSource?
	
	fileprivate let background: ImagePreviewViewBackground
	fileprivate let titleBar: ImagePreviewViewTitleBar
	fileprivate let toolBar: ImagePreviewViewToolBar
	
	fileprivate var imageView: ImagePreviewViewImageView
	
	fileprivate var hideBarsTimer: Timer?
	
	public init() {
		
		self.background = ImagePreviewViewBackground()
		self.titleBar = ImagePreviewViewTitleBar()
		self.toolBar = ImagePreviewViewToolBar()
		
		self.imageView = ImagePreviewViewImageView()
		
		super.init(frame: .zero)
		
		self.backgroundColor = .clear
		self.addSubview(self.background)
		self.addSubview(self.imageView)
		self.addSubview(self.titleBar)
		self.addSubview(self.toolBar)
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		self.layoutBackground()
		self.layoutTitleBar()
		self.layoutToolBar()
		self.layoutImageView()
	}
	
	private func layoutBackground() {
		let view = self.background
		view.frame = self.bounds
	}
	
	private func layoutTitleBar() {
		let view = self.titleBar
		view.frame.origin = .zero
		view.frame.size.width = self.bounds.width
		view.frame.size.height = 40 + UIApplication.shared.statusBarFrame.height
	}
	
	private func layoutToolBar() {
		let view = self.toolBar
		view.frame.origin.x = 0
		view.frame.origin.y = self.bounds.height - 40
		view.frame.size.width = self.bounds.width
		view.frame.size.height = 40
	}
	
	private func layoutImageView() {
		let view = self.imageView
		view.frame = self.bounds
	}
	
}

extension ImagePreviewView {
	
	@objc private func hideBars(sender: Timer) {
		self.hideBars()
	}
	
	func hideBars(after timeInterval: TimeInterval) {
		
		if let timer = self.hideBarsTimer {
			timer.invalidate()
			self.hideBarsTimer = nil
		}
		
		let timer = Timer.scheduledTimer(timeInterval: timeInterval,
		                                 target: self,
		                                 selector: #selector(self.hideBars(sender:)),
		                                 userInfo: nil,
		                                 repeats: false)
		self.hideBarsTimer = timer
		
	}
	
}

extension ImagePreviewView {
	
	func setBackgroundAlpha(to alpha: CGFloat) {
		self.background.alpha = alpha
	}
	
}

extension ImagePreviewView {
	
	func showBars() {
		self.titleBar.show()
		self.toolBar.show()
		self.hideBars(after: 2)
	}
	
	func hideBars() {
		self.titleBar.hide()
		self.toolBar.hide()
	}
	
}

extension ImagePreviewView {
	
	func updateImage() {
		
		guard let image = self.dataSource?.getImage(for: self) else {
			return
		}
		
		self.imageView.image = image
		
	}
	
}

extension ImagePreviewView {
	
	func setOnImageTappedAction(_ action: ((_ recognizer: UITapGestureRecognizer, _ view: UIView) -> Void)?) {
		self.imageView.setOnTapGestureRecognizedAction(action)
	}
	
	func setOnImagePannedAction(_ action: ((_ recognizer: UIPanGestureRecognizer, _ view: UIView) -> Void)?) {
		self.imageView.setOnPanGestureRecognizedAction(action)
	}
	
}

extension ImagePreviewView {
	
	func setOnBackButtonTappedAction(_ action: @escaping () -> Void) {
		self.titleBar.setOnBackButtonTappedAction(action)
	}
	
}

extension ImagePreviewView {
	
	func setButtonsInToolbar(_ buttons: [UIButton]) {
		buttons.forEach { (button) in
			self.toolBar.addSubview(button)
		}
	}
	
}
