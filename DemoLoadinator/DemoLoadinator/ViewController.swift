//
//  ViewController.swift
//  DemoLoadinator
//
//  Created by Michael Redig on 6/19/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit
import LoadinationIndicator

class ViewController: UIViewController {
	var animatedLoadingView: LoadinationAnimatorView?

	override func viewDidLoad() {
		super.viewDidLoad()

		let animationView = LoadinationAnimatorView.fullscreenOverlay()
		animationView?.animation = .bounce
		animationView?.beginAnimation()

//		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//			animationView?.endAnimation()
//			animationView?.removeFromSuperview()
//		}
	}

	@IBAction func playPressed(_ sender: UIBarButtonItem) {
		animatedLoadingView = LoadinationAnimatorView(frame: view.frame)
		animatedLoadingView?.statusLabelPosition = .bottom
		view.addSubview(animatedLoadingView!)
		animatedLoadingView?.beginAnimation()
	}

	@IBAction func stopPressed(_ sender: UIBarButtonItem) {
		UIView.animate(withDuration: 0.2, animations: { [weak self] in
			self?.animatedLoadingView?.alpha = 0
		}) { [weak self] _ in
			self?.animatedLoadingView?.removeFromSuperview()
		}
	}

	@IBAction func nowPressed(_ sender: UIBarButtonItem) {
//		animatedLoadingView.endAnimation(immediately: true)
	}

}

