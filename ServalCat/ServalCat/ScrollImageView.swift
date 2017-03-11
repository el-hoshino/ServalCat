//
//  ScrollImageView.swift
//  ImagePreviewer
//
//  Created by 史　翔新 on 2017/03/10.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import UIKit

class ScrollImageView: UIScrollView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.isPagingEnabled = true
	}
	
	convenience init() {
		self.init(frame: .zero)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.layoutImageViews()
	}
	
}

extension ScrollImageView {
	
	fileprivate func layoutImageViews() {
		
		let imageViews = self.subviews.flatMap { $0 as? UIImageView }
		let imageCount = imageViews.count
		
		imageViews.enumerated().forEach { (i, view) in
			view.frame.size = self.bounds.size
			view.frame.origin.y = 0
			view.frame.origin.x = self.bounds.width * CGFloat(i)
		}
		
		self.contentSize.height = self.bounds.height
		self.contentSize.width = self.bounds.width * CGFloat(imageCount)
		
	}
	
}

extension ScrollImageView {
	
	private func removeAllSubviews() {
		
		self.subviews.forEach { (subview) in
			subview.removeFromSuperview()
		}
		
	}
	
	private func addImages(_ images: [UIImage]) {
		
		images.forEach { (image) in
			let view = UIImageView(image: image)
			view.contentMode = .scaleAspectFit
			self.addSubview(view)
		}
		
	}
	
	func setImages(_ images: [UIImage]) {
		
		self.removeAllSubviews()
		self.addImages(images)
		self.setNeedsLayout()
		
	}
	
}
