//
//  AnimationView.swift
//  LoadinationIndicator
//
//  Created by Michael Redig on 6/19/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

public class AnimationView: UIView {

	// MARK: - Properties: IB
	@IBOutlet var contentView: UIView!
	@IBOutlet var animatedViews: [UIView]!


	@IBOutlet public var statusLabel: UILabel!
	@IBOutlet var statusBottomAnchor: NSLayoutConstraint!
	@IBOutlet var statusTopAnchor: NSLayoutConstraint!

	// MARK: - Properties: Status
	private var animationStopping: Bool = false

	public var isAnimating: Bool {
		for blob in animatedViews {
			if blob.layer.animationKeys() != nil {
				return true
			}
		}
		return false
	}

	// MARK: - Options
	public enum StatusLabelPosition {
		case top, bottom
	}
	public var statusLabelPosition = StatusLabelPosition.bottom {
		didSet {
			switch statusLabelPosition {
			case .top:
				statusBottomAnchor.isActive = false
				statusTopAnchor.isActive = true
			case .bottom:
				statusTopAnchor.isActive = false
				statusBottomAnchor.isActive = true
			}
		}
	}

	public var animation = Animation.growFade
	public enum Animation {
		case growFade
		case bounce
	}

	// MARK: - Inits
	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		let bundle = Bundle.init(for: type(of: self))
		let nib = UINib(nibName: "AnimationView", bundle: bundle)
		nib.instantiate(withOwner: self, options: nil)
		contentView.frame = bounds
		addSubview(contentView)

		for blob in animatedViews {
			blob.layer.cornerRadius = blob.frame.height / 2
			blob.backgroundColor = .white
		}
	}

	// MARK: - Controls
	public func beginAnimation() {
		animationStopping = false
		for (index, blob) in animatedViews.enumerated() {
			switch animation {
			case .bounce:
				animateBounce(view: blob, delayed: Double(index))
			case .growFade:
				animateGrowFade(view: blob, delayed: Double(index) * 1)
			}
		}
	}

	public func endAnimation(immediately immediate: Bool = false) {
		animationStopping = true
		if immediate {
			for blob in animatedViews {
				blob.layer.removeAllAnimations()
				blob.transform = CGAffineTransform(scaleX: 0, y: 0)
				blob.alpha = 0
			}
		}
	}

}

// MARK: - Actual Animations
extension AnimationView {
	private func animateGrowFade(view: UIView, duration: TimeInterval = 3, delayed: TimeInterval = 0) {
		view.transform = CGAffineTransform(scaleX: 0, y: 0)
		view.alpha = 0
		guard animationStopping == false else { return }
		UIView.animateKeyframes(withDuration: duration, delay: delayed, options: [.calculationModePaced], animations: {
			UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 1, animations: {
				view.transform = CGAffineTransform(scaleX: 3, y: 3)
			})
			UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4, animations: {
				view.alpha = 1
			})
			UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
				view.alpha = 0
			})
		}) { [weak self] _ in
			self?.animateGrowFade(view: view, duration: duration)
		}
	}

	private func animateBounce(view: UIView, duration: TimeInterval = 3, delayed: TimeInterval = 0) {
		view.transform = CGAffineTransform(scaleX: 1, y: 1)
		let bounceStart = CGAffineTransform(translationX: 0, y: 120)
		view.transform = bounceStart
		view.alpha = 0

		guard animationStopping == false else { return }

		let fades = {
			UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
				UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.01, animations: {
					view.alpha = 1.0
				})
				UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
					view.alpha = 0
				})
			})
		}

		let dampening: CGFloat = 0.3
		let bounce = {
			UIView.animate(withDuration: duration / 3, delay: 0, usingSpringWithDamping: dampening, initialSpringVelocity: 0, options: [], animations: {
				view.transform = .identity
			})
			UIView.animate(withDuration: duration / 6, delay: (duration / 6) * 5, options: [], animations: {
				view.transform = bounceStart
			}, completion: { [weak self] _ in
				self?.animateBounce(view: view, duration: duration, delayed: 0.2)
			})
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + delayed) {
			fades()
			bounce()
		}

	}
}

// MARK: - Special
extension AnimationView {
	public static func fullscreenOverlay() -> AnimationView? {
		guard let rootView = UIApplication.shared.delegate?.window??.rootViewController?.view else { return nil }
		let animationView = AnimationView(frame: rootView.frame)
		rootView.addSubview(animationView)
		return animationView
	}
}
