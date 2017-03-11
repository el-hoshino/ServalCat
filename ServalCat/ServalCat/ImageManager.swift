//
//  ImageManager.swift
//  ServalCat
//
//  Created by 史　翔新 on 2017/03/10.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import Foundation

class ImageManager {
	
	let images: [UIImage]
	fileprivate(set) var index: Int = 0
	
	init(images: [UIImage]) {
		self.images = images
	}
	
	convenience init() {
		self.init(images: [])
	}
	
}

extension ImageManager {
	
	var canDecreaseIndex: Bool {
		return self.images.indices.contains(self.index.decreased)
	}
	
	var canIncreaseIndex: Bool {
		return self.images.indices.contains(self.index.increased)
	}
	
}

extension ImageManager {
	
	func setIndex(to newIndex: Int) {
		
		if self.images.indices.contains(newIndex) {
			self.index = newIndex
		}
		
	}
	
	func increaseIndex() {
		
		let newIndex = self.index.increased
		
		if self.images.indices.contains(newIndex) {
			self.index = newIndex
		}
		
	}
	
	func decreaseIndex() {
		
		let newIndex = self.index.decreased
		
		if self.images.indices.contains(newIndex) {
			self.index = newIndex
		}
		
	}
	
}

extension ImageManager {
	
	func getImage(at index: Int) -> UIImage? {
		
		guard self.images.indices.contains(index) else {
			return nil
		}
		
		return self.images[index]
		
	}
	
}

extension ImageManager: ImagePreviewViewDataSource {
	
	func getImage(for imagePreviewView: ImagePreviewView) -> UIImage? {
		return self.getImage(at: self.index)
	}
	
	func getNextImage(for imagePreviewView: ImagePreviewView) -> UIImage? {
		return self.getImage(at: self.index.increased)
	}
	
	func getPreviousImage(for imagePreviewView: ImagePreviewView) -> UIImage? {
		return self.getImage(at: self.index.decreased)
	}
	
}

private extension Int {
	
	var increased: Int {
		return self + 1
	}
	
	var decreased: Int {
		return self - 1
	}
	
}
