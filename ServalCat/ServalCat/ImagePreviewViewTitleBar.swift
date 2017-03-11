//
//  ImagePreviewViewTitleBar.swift
//  ServalCat
//
//  Created by 史　翔新 on 2017/03/10.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import UIKit

class ImagePreviewViewTitleBar: UIView, Showable, Hideable {
	
	fileprivate let titleLabel: UILabel
	fileprivate let backButton: UIButton
	
	fileprivate var onBackButtonTapped: (() -> Void)?
	
	init() {
		
		self.titleLabel = UILabel()
		self.backButton = UIButton()
		
		super.init(frame: .zero)
		
		self.setupView()
		self.setupLabel()
		self.setupButton()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.layoutTitleLabel()
		self.layoutBackButton()
	}
	
	private func setupView() {
		self.alpha = 0
		self.backgroundColor = UIColor(white: 0, alpha: 0.5)
	}
	
	private func setupLabel() {
		let view = self.titleLabel
		view.textColor = .white
		self.addSubview(view)
	}
	
	private func setupButton() {
		let view = self.backButton
		view.setTitleColor(.white, for: .normal)
		view.setTitle("⬅️", for: .normal)
		view.addTarget(self, action: #selector(self.onBackButtonTapped(sender:)), for: .touchUpInside)
		self.addSubview(view)
	}
	
	private func layoutTitleLabel() {
		let view = self.titleLabel
		view.frame.size.width = self.bounds.width * 0.6
		view.frame.size.height = 40
		view.frame.origin.x = self.bounds.width * 0.2
		view.frame.origin.y = self.bounds.height - 40
	}
	
	private func layoutBackButton() {
		let view = self.backButton
		view.frame.size.width = self.bounds.width * 0.2
		view.frame.size.height = 40
		view.frame.origin.x = 0
		view.frame.origin.y = self.bounds.height - 40
	}
	
}

extension ImagePreviewViewTitleBar {
	
	@objc fileprivate func onBackButtonTapped(sender: UIButton) {
		self.onBackButtonTapped?()
	}
	
}

extension ImagePreviewViewTitleBar {
	
	@objc fileprivate func onStatusBarFrameChanged(sender: NSNotification) {
		self.setNeedsLayout()
	}
	
}

extension ImagePreviewViewTitleBar {
	
	func setOnBackButtonTappedAction(_ action: @escaping () -> Void) {
		self.onBackButtonTapped = action
	}
	
}
