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
	
	fileprivate var onTapGestureRecognized: ((_ recognizer: UITapGestureRecognizer, _ view: UIView) -> Void)?
	fileprivate var onPanGestureRecognized: ((_ recognizer: UIPanGestureRecognizer, _ view: UIView) -> Void)?
	
	override init(frame: CGRect) {
		self.imageView = UIImageView()
		super.init(frame: frame)
		self.setupImageView()
		self.setupGestureRecognizer()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		print("ImagePreviewViewImageView deinited")
	}
	
	private func setupImageView() {
		let view = self.imageView
		view.frame = self.bounds
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.contentMode = .scaleAspectFit
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
		self.onTapGestureRecognized?(sender, self)
	}
	
	@objc fileprivate func onPanGestureRecognized(sender: UIPanGestureRecognizer) {
		self.onPanGestureRecognized?(sender, self)
	}
	
}

extension ImagePreviewViewImageView {
	
	func setOnTapGestureRecognizedAction(_ action: ((_ recognizer: UITapGestureRecognizer, _ view: UIView) -> Void)?) {
		self.onTapGestureRecognized = action
	}
	
	func setOnPanGestureRecognizedAction(_ action: ((_ recognizer: UIPanGestureRecognizer, _ view: UIView) -> Void)?) {
		self.onPanGestureRecognized = action
	}
	
}
