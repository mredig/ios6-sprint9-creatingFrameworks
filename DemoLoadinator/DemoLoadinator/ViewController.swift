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
	@IBOutlet var animatedLoadingView: AnimationView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	@IBAction func playPressed(_ sender: UIBarButtonItem) {
		animatedLoadingView.beginAnimation()
	}

	@IBAction func stopPressed(_ sender: UIBarButtonItem) {
		animatedLoadingView.endAnimation(immediately: false)
	}

	@IBAction func nowPressed(_ sender: UIBarButtonItem) {
		animatedLoadingView.endAnimation(immediately: true)
	}

}

