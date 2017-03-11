//
//  Showable.swift
//  ServalCat
//
//  Created by 史　翔新 on 2017/03/10.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import UIKit

protocol Showable: class {
	func show()
}

extension Showable where Self: UIView {
	
	private func setAlpha() {
		UIView.animate(withDuration: 0.1) {
			self.alpha = 1
		}
	}
	
	func show() {
		if Thread.isMainThread {
			self.setAlpha()
		} else {
			DispatchQueue.main.async {
				self.setAlpha()
			}
		}
	}
	
}
