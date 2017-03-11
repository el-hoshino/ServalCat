//
//  ImageManager.swift
//  ImagePreviewer
//
//  Created by 史　翔新 on 2017/03/10.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import Foundation

class ImageManager {
	
	var images: [UIImage]
	
	init(images: [UIImage]) {
		self.images = images
	}
	
	convenience init() {
		self.init(images: [])
	}
	
}

extension ImageManager: ImagePreviewViewDataSource {
	
	func getImages(for imagePreviewView: ImagePreviewView) -> [UIImage] {
		return self.images
	}
	
}
