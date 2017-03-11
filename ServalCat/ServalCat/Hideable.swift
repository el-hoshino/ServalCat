//
//  Hideable.swift
//  ServalCat
//
//  Created by 史　翔新 on 2017/03/10.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import UIKit

protocol Hideable: class {
	func hide()
}

extension Hideable where Self: UIView {
	
	private func setAlpha() {
		UIView.animate(withDuration: 0.5) { 
			self.alpha = 0
		}
	}
	
	func hide() {
		if Thread.isMainThread {
			self.setAlpha()
		} else {
			DispatchQueue.main.async {
				self.setAlpha()
			}
		}
	}
	
}
