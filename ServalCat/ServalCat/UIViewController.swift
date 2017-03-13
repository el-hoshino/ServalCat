//
//  UIViewController.swift
//  ServalCat
//
//  Created by 史　翔新 on 2017/03/11.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import UIKit

extension UIViewController {
	
	public func showImagePreviewController(_ controller: ImagePreviewController, withImageAt index: Int, from thumbnailView: UIView? = nil) {
		
		let animated = thumbnailView != nil
		
		self.viewWillDisappear(animated)
		
		self.addChildViewController(controller)
		controller.view.frame = self.view.bounds
		
		self.view.addSubview(controller.view)
		controller.didMove(toParentViewController: self)
		
		if let thumbnailView = thumbnailView {
			
			let frame = thumbnailView.convert(thumbnailView.bounds, to: controller.previewView)
			controller.initialize(imageIndex: index, initialFrame: frame)
			
			UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
				controller.showUpAfterMovedToParentController()
				
			}, completion: { _ in
				controller.postShowUpProcess()
				self.viewDidDisappear(animated)
			})
			
		} else {
			controller.initialize(imageIndex: index, initialFrame: nil)
			controller.showUpAfterMovedToParentController()
			controller.postShowUpProcess()
			self.viewDidDisappear(animated)
		}
		
	}
	
	public func hideImagePreviewController(_ controller: ImagePreviewController, to thumbnailView: ((Int) -> UIView?)? = nil) {
		
		guard let parent = controller.parent, self === parent else {
			return
		}
		
		let animated = thumbnailView != nil
		
		controller.willMove(toParentViewController: nil)
		
		self.viewWillAppear(animated)
		
		controller.preHideProcess()
		
		func postMoveAction() {
			controller.view.removeFromSuperview()
			controller.removeFromParentViewController()
			self.viewDidAppear(animated)
		}
		
		if let thumbnailView = thumbnailView?(controller.currentIndex) {
			
			let frame = thumbnailView.convert(thumbnailView.bounds, to: controller.previewView)
			
			UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
				controller.hideBeforeRemovingFromParentController(andMoveCurrentImageTo: frame)
				
			}, completion: { (finished) in
				postMoveAction()
			})
			
		} else {
			postMoveAction()
		}
		
	}
	
}
