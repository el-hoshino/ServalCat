//
//  ThumbnailImageButton.swift
//  ServalCat
//
//  Created by 史　翔新 on 2017/03/11.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import UIKit

public class ThumbnailImageButton: UIButton{
	
	fileprivate var onButtonTapped: ((ThumbnailImageButton) -> Void)?
	
	var thumbnailImage: UIImage? {
		willSet {
			self.setImage(newValue, for: .normal)
		}
	}
	
	public init(image: UIImage?) {
		
		self.thumbnailImage = image
		let size = image?.size ?? .zero
		let frame = CGRect(origin: .zero, size: size)
		
		super.init(frame: frame)
		
		self.imageView?.contentMode = .scaleAspectFit
		self.setImage(image, for: .normal)
		self.addTarget(self, action: #selector(self.onTapped(sender:)), for: .touchUpInside)
		
	}
	
	convenience public init() {
		self.init(image: nil)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.addTarget(self, action: #selector(self.onTapped(sender:)), for: .touchUpInside)
	}
	
	deinit {
		print("ThumbnailImageButton deinited")
	}
	
}

extension ThumbnailImageButton {
	
	@objc fileprivate func onTapped(sender: ThumbnailImageButton) {
		self.onButtonTapped?(sender)
	}
	
}

extension ThumbnailImageButton {
	
	public func setOnButtonTappedAction(_ action: ((ThumbnailImageButton) -> Void)?) {
		self.onButtonTapped = action
	}
	
}
