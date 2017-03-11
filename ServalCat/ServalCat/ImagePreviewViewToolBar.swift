//
//  ImagePreviewViewToolBar.swift
//  ServalCat
//
//  Created by 史　翔新 on 2017/03/10.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import UIKit

class ImagePreviewViewToolBar: UIView {
	
	init() {
		
		super.init(frame: .zero)
		
		self.setupView()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		print("ImagePreviewViewToolBar deinited")
	}
	
	private func setupView() {
		self.alpha = 0
		self.backgroundColor = UIColor(white: 0, alpha: 0.5)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.layoutButtons()
	}
	
	private func layoutButtons() {
		let buttons = self.subviews.flatMap { $0 as? UIButton }
		let buttonCount = buttons.count
		let buttonWidth = self.bounds.width / CGFloat(buttonCount)
		buttons.enumerated().forEach { (i, button) in
			button.frame.origin.x = buttonWidth * CGFloat(i)
			button.frame.origin.y = 0
			button.frame.size.width = buttonWidth
			button.frame.size.height = self.bounds.size.height
		}
	}
	
}

extension ImagePreviewViewToolBar: Showable, Hideable {
	
	private func setAlpha() {
		self.alpha = 1
	}
	
	func show() {
		
		guard self.subviews.first(where: {$0 is UIButton}) != nil else {
			return
		}
		
		if Thread.isMainThread {
			self.setAlpha()
		} else {
			DispatchQueue.main.async {
				self.setAlpha()
			}
		}
		
	}
	
}
