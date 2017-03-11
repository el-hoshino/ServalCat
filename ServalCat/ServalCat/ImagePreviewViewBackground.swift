//
//  ImagePreviewViewBackground.swift
//  ServalCat
//
//  Created by 史　翔新 on 2017/03/11.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import UIKit

class ImagePreviewViewBackground: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .black
		self.alpha = 0
	}
	
	convenience init() {
		self.init(frame: .zero)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		print("ImagePreviewViewBackground deinited")
	}
	
}
