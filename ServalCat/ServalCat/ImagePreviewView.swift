//
//  ImagePreviewView.swift
//  ServalCat
//
//  Created by 史　翔新 on 2017/03/10.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import UIKit

protocol ImagePreviewViewDataSource: class {
	func getImages(for imagePreviewView: ImagePreviewView) -> [UIImage]
}

public class ImagePreviewView: UIView {
	
	weak var dataSource: ImagePreviewViewDataSource?
	
	fileprivate let titleBar: ImagePreviewViewTitleBar
	fileprivate let imageView: ScrollImageView
	fileprivate let toolBar: ImagePreviewViewToolBar
	
	public init() {
		
		self.titleBar = ImagePreviewViewTitleBar()
		self.imageView = ScrollImageView()
		self.toolBar = ImagePreviewViewToolBar()
		
		super.init(frame: .zero)
		
		self.backgroundColor = .white
		self.addSubview(self.imageView)
		self.addSubview(self.titleBar)
		self.addSubview(self.toolBar)
		
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		self.layoutTitleBar()
		self.layoutToolBar()
		self.layoutImageView()
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
	
	func showBars() {
		self.titleBar.show()
		self.toolBar.show()
	}
	
	func hideBars() {
		self.titleBar.hide()
		self.toolBar.hide()
	}
	
}

extension ImagePreviewView {
	
	func updateImages() {
		
		guard let images = self.dataSource?.getImages(for: self) else {
			return
		}
		
		self.imageView.setImages(images)
		
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
