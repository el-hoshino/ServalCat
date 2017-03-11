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
	
	override init(frame: CGRect) {
		self.imageView = UIImageView()
		super.init(frame: frame)
		self.setupImageView()
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
	
}
