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
	
	fileprivate var onTapGestureRecognized: ((_ recognizer: UITapGestureRecognizer, _ view: ImagePreviewView) -> Void)?
	fileprivate var onPanGestureRecognized: ((_ recognizer: UIPanGestureRecognizer, _ view: ImagePreviewView) -> Void)?
	
	fileprivate let background: ImagePreviewViewBackground
	fileprivate let gestureRecognizingView: UIView
	fileprivate let titleBar: ImagePreviewViewTitleBar
	fileprivate let toolBar: ImagePreviewViewToolBar
	
	fileprivate let previousImageView: ImagePreviewViewImageView
	fileprivate let currentImageView: ImagePreviewViewImageView
	fileprivate let nextImageView: ImagePreviewViewImageView
	
	fileprivate var hideBarsTimer: Timer?
	
	public init() {
		
		self.background = ImagePreviewViewBackground()
		self.gestureRecognizingView = UIView()
		self.titleBar = ImagePreviewViewTitleBar()
		self.toolBar = ImagePreviewViewToolBar()
		
		self.previousImageView = ImagePreviewViewImageView()
		self.currentImageView = ImagePreviewViewImageView()
		self.nextImageView = ImagePreviewViewImageView()
		
		super.init(frame: .zero)
		
		self.setupView()
		self.addSubviews()
		self.setupSubviews()
		self.setupGestureRecognizer()
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		self.layoutBackground()
		self.layoutGestureRecognizingView()
		self.layoutTitleBar()
		self.layoutToolBar()
		self.layoutImageViews()
	}
	
	private func layoutBackground() {
		let view = self.background
		view.frame = self.bounds
	}
	
	private func layoutGestureRecognizingView() {
		let view = self.gestureRecognizingView
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
	
	private func layoutImageViews() {
		
		self.previousImageView.frame = self.viewFrame(for: .previous)
		self.nextImageView.frame = self.viewFrame(for: .next)
		
	}
	
	private func setupView() {
		self.backgroundColor = .clear
	}
	
	private func addSubviews() {
		self.addSubview(self.background)
		self.addSubview(self.gestureRecognizingView)
		self.addSubview(self.previousImageView)
		self.addSubview(self.currentImageView)
		self.addSubview(self.nextImageView)
		self.addSubview(self.titleBar)
		self.addSubview(self.toolBar)
	}
	
	private func setupPreviousAndNextImageView() {
		self.previousImageView.isHidden = true
		self.nextImageView.isHidden = true
	}
	
	private func setupCurrentImageView() {
		let view = self.currentImageView
		view.frame = self.bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
	}
	
	private func setupSubviews() {
		self.setupPreviousAndNextImageView()
		self.setupCurrentImageView()
	}
	
	private func setupGestureRecognizer() {
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTapGestureRecognized(sender:)))
		self.addGestureRecognizer(tapGestureRecognizer)
		
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.onPanGestureRecognized(sender:)))
		self.addGestureRecognizer(panGestureRecognizer)
		
	}
	
}

extension ImagePreviewView {
	
	var currentImagePosition: CGPoint {
		return self.currentImageView.frame.origin
	}
	
}

extension ImagePreviewView {
	
	enum PreviewImageView {
		case previous
		case current
		case next
	}
	
	func viewFrame(for view: PreviewImageView, withOffset offset: CGPoint = .zero) -> CGRect {
		
		var basicFrame = self.bounds
		
		switch view {
		case .previous:
			basicFrame.origin.x = -self.bounds.width * 1.1
			
		case .current:
			break
			
		case .next:
			basicFrame.origin.x = self.bounds.width * 1.1
		}
		
		basicFrame.origin += offset
		
		return basicFrame
		
	}
	
}

extension ImagePreviewView {
	
	@objc fileprivate func onTapGestureRecognized(sender: UITapGestureRecognizer) {
		self.onTapGestureRecognized?(sender, self)
	}
	
	@objc fileprivate func onPanGestureRecognized(sender: UIPanGestureRecognizer) {
		self.onPanGestureRecognized?(sender, self)
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
	
	func setCurrentImageFrame(_ frame: CGRect?) {
		if let frame = frame {
			self.currentImageView.frame = frame
		}
	}
	
}

extension ImagePreviewView {
	
	func setImageViewPosition(withTranslation translation: CGPoint) {
		
		self.previousImageView.frame = self.viewFrame(for: .previous, withOffset: translation)
		self.currentImageView.frame = self.viewFrame(for: .current, withOffset: translation)
		self.nextImageView.frame = self.viewFrame(for: .next, withOffset: translation)
		
	}
	
}

extension ImagePreviewView {
	
	func setImageDismissingProgress(to progress: CGFloat) {
		
		let alpha = 1 - progress
		self.setBackgroundAlpha(to: alpha)
		self.setCurrentImageViewAlpha(to: alpha)
		
		let width = (1 - progress * progress) * self.bounds.width
		let x = (self.bounds.width - width) / 2
		self.currentImageView.frame.origin.x = x
		self.currentImageView.frame.size.width = width
		
	}
	
}

extension ImagePreviewView {
	
	private func animate(_ animations: @escaping () -> Void, preSwitching: (() -> Void)?) {
		
		UIView.animate(withDuration: 0.2, animations: { 
			animations()
			
		}) { (_) in
			preSwitching?()
			self.updateImages()
			self.setImageViewPosition(withTranslation: .zero)
		}
		
	}
	
	func setToPreviousImage(preSwitching: (() -> Void)?) {
		
		self.animate({ 
			self.previousImageView.frame = self.viewFrame(for: .current)
			self.currentImageView.frame = self.viewFrame(for: .next)
			self.nextImageView.frame = self.viewFrame(for: .next)
		}, preSwitching: preSwitching)
		
		
	}
	
	func setToCurrentImage(preSwitching: (() -> Void)?) {
		
		self.animate({ 
			self.previousImageView.frame = self.viewFrame(for: .previous)
			self.currentImageView.frame = self.viewFrame(for: .current)
			self.nextImageView.frame = self.viewFrame(for: .next)
		}, preSwitching: preSwitching)
		
	}
	
	func setToNextImage(preSwitching: (() -> Void)?) {
		
		self.animate({ 
			self.previousImageView.frame = self.viewFrame(for: .previous)
			self.currentImageView.frame = self.viewFrame(for: .previous)
			self.nextImageView.frame = self.viewFrame(for: .current)
		}, preSwitching: preSwitching)
		
	}
	
}

extension ImagePreviewView {
	
	func setBackgroundAlpha(to alpha: CGFloat) {
		self.background.alpha = alpha
	}
	
}

extension ImagePreviewView {
	
	func setCurrentImageViewAlpha(to alpha: CGFloat) {
		self.currentImageView.alpha = alpha
	}
	
}

extension ImagePreviewView {
	
	func placePreviewImages() {
		
		self.previousImageView.frame = self.viewFrame(for: .previous)
		self.currentImageView.frame = self.viewFrame(for: .current)
		self.nextImageView.frame = self.viewFrame(for: .next)
		
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
	
	func showPreviousAndNextImagePreviewView() {
		self.previousImageView.isHidden = false
		self.nextImageView.isHidden = false
	}
	
	func hidePreviousAndNextImagePreoviewView() {
		self.previousImageView.isHidden = true
		self.nextImageView.isHidden = true
	}
	
}

extension ImagePreviewView {
	
	func updateImages() {
		
		guard let image = self.dataSource?.getImage(for: self) else {
			return
		}
		
		self.currentImageView.image = image
		
		self.previousImageView.image = self.dataSource?.getPreviousImage(for: self)
		self.nextImageView.image = self.dataSource?.getNextImage(for: self)
		
	}
	
}

extension ImagePreviewView {
	
	func setOnImageTappedAction(_ action: ((_ recognizer: UITapGestureRecognizer, _ view: ImagePreviewView) -> Void)?) {
		self.onTapGestureRecognized = action
	}
	
	func setOnImagePannedAction(_ action: ((_ recognizer: UIPanGestureRecognizer, _ view: ImagePreviewView) -> Void)?) {
		self.onPanGestureRecognized = action
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

private func += (lhs: inout CGPoint, rhs: CGPoint) {
	lhs = CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
