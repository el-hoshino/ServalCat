//
//  UIViewController.swift
//  ServalCat
//
//  Created by 史　翔新 on 2017/03/11.
//  Copyright © 2017年 Crazism. All rights reserved.
//

import UIKit

extension UIViewController {
	
	public func showImagePreviewController(_ controller: ImagePreviewController, from thumbnailView: UIView? = nil) {
		
		let animated = thumbnailView != nil
		
		controller.willMove(toParentViewController: self)
		
		self.viewWillDisappear(animated)
		controller.viewWillAppear(animated)
		
		self.addChildViewController(controller)
		controller.view.frame = self.view.bounds
		
		self.view.addSubview(controller.view)
		controller.didMove(toParentViewController: self)
		
		if let thumbnailView = thumbnailView {
			UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
				controller.showUpAfterMovedToParentController()
			}, completion: { finished in
//				completion?(finished)
				controller.viewDidAppear(animated)
				self.viewDidDisappear(animated)
			})
			
		} else {
//			completion?(true)
			controller.showUpAfterMovedToParentController()
			controller.viewDidAppear(animated)
			self.viewDidDisappear(animated)
		}
		
	}
	
	public func hideImagePreviewController(_ controller: ImagePreviewController, to thumbnailView: UIView? = nil) {
		
		guard let parent = controller.parent, self === parent else {
			return
		}
		
		let animated = thumbnailView != nil
		
		controller.willMove(toParentViewController: nil)
		
		controller.viewWillDisappear(animated)
		self.viewWillAppear(animated)
		
		func moveView() {
//			self.view.frame.origin.x = parent.view.bounds.width
		}
		
		func postMoveAction() {
			controller.view.removeFromSuperview()
			controller.removeFromParentViewController()
			controller.didMove(toParentViewController: nil)
		}
		
		if let thumbnailView = thumbnailView {
			UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
				moveView()
			}, completion: { (finished) in
				postMoveAction()
//				completion?(finished)
				parent.viewDidAppear(animated)
				self.viewDidDisappear(animated)
			})
			
		} else {
			postMoveAction()
//			completion?(true)
			self.viewDidAppear(animated)
			controller.viewDidDisappear(animated)
		}
		
	}
	
}
