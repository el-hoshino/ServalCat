//
//  ImagePreviewViewImageView.swift
//  ServalCat
//
//  Created by 史　翔新 on 2017/03/11.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import UIKit

class ImagePreviewViewImageView: UIView {
	
	private let imageView: UIImageView
	
	var image: UIImage? {
		set {
			self.imageView.image = newValue
		}
		get {
			return self.imageView.image
		}
	}
	
	fileprivate var onTapGestureRecognized: ((UIView) -> Void)?
	fileprivate var onPanGestureRecognized: ((_ translation: CGPoint, _ view: UIView) -> Void)?
	
	override init(frame: CGRect) {
		self.imageView = UIImageView()
		super.init(frame: frame)
		self.setupImageView()
		self.setupGestureRecognizer()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupImageView() {
		let view = self.imageView
		view.frame = self.bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.addSubview(view)
	}
	
	private func setupGestureRecognizer() {
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTapGestureRecognized(sender:)))
		self.addGestureRecognizer(tapGestureRecognizer)
		
		let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.onPanGestureRecognized(sender:)))
		self.addGestureRecognizer(panGestureRecognizer)
		
	}
	
}

extension ImagePreviewViewImageView {
	
	@objc fileprivate func onTapGestureRecognized(sender: UITapGestureRecognizer) {
		self.onTapGestureRecognized?(self)
	}
	
	@objc fileprivate func onPanGestureRecognized(sender: UIPanGestureRecognizer) {
		let translation = sender.translation(in: nil)
		self.onPanGestureRecognized?(translation, self)
		sender.setTranslation(.zero, in: nil)
	}
	
}

extension ImagePreviewViewImageView {
	
	func setOnTapGestureRecognizedAction(_ action: ((UIView) -> Void)?) {
		self.onTapGestureRecognized = action
	}
	
	func setOnPanGestureRecognizedAction(_ action: ((_ translation: CGPoint, _ view: UIView) -> Void)?) {
		self.onPanGestureRecognized = action
	}
	
}
