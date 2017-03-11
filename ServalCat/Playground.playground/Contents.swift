//: Playground - noun: a place where people can play

import UIKit
import ServalCat
import PlaygroundSupport

let controller = UIViewController()
let view = controller.view
view?.frame = CGRect(x: 0, y: 0, width:  320, height: 568)
view?.backgroundColor = .white
PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true

let image1 = #imageLiteral(resourceName: "lena_std.png")
let image2 = #imageLiteral(resourceName: "l_hires.png")

let button1 = ThumbnailImageButton(image: image1)
let button2 = ThumbnailImageButton(image: image2)

button1.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
button2.frame = CGRect(x: 120, y: 10, width: 100, height: 100)

view?.addSubview(button1)
view?.addSubview(button2)

let images = [image1, image2]
let buttons = [button1, button2]

buttons.enumerated().forEach { (i, button) in
	
	button.setOnButtonTappedAction { (button) in
		let previewController = ImagePreviewController(images: images)
		previewController.setDismissAction({ (previewController) in
			controller.hideImagePreviewController(previewController, to: {buttons[$0]})
		})
		controller.showImagePreviewController(previewController, withImageAt: i, from: button)
	}
	
}

