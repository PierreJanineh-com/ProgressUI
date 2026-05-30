//
//  Options.swift
//  ProgressUI
//
//  Created by Pierre Janineh on 09/05/2025.
//

import SwiftUI

/// Options for customizing the appearance and behavior of ProgressUI.
public struct Options {
	/**
	 Creates a configuration for ``ProgressUI``.

	 Every parameter has a default, so you only need to specify the values you
	 want to override, e.g. `Options(isRounded: false, progressColor: .blue)`.

	 - Parameters:
	    - size: The size preset. Default: ``ProgressSize/large``.
	    - trackColor: The color of the empty track. Default: `Color.black`.
	    - trackWidth: An explicit track width. Default: `nil` (derived from `size`).
	    - progressColor: The progress color. Default: `Color.green`.
	    - animationMaxValue: Progress threshold for the start-of-growth width animation. `nil` disables it. Default: `0.03`.
	    - animation: The animation applied to progress changes. Default: `.easeInOut(duration: 0.5)`.
	    - innerProgressWidth: An explicit inner progress width. Default: `nil` (derived from `size`).
	    - innerProgressColor: The inner progress color. Default: `Color.black.opacity(0.2)`.
	    - isRounded: Whether line caps are rounded. Default: `true`.
	    - isClockwise: Whether the spinner rotates clockwise. Default: `true`.
	    - growFrom: The direction the progress grows from. Default: ``GrowDirection/end``.
	    - isSpinner: Whether to run in indeterminate spinner mode. Default: `false`.
	    - spinnerCycleDuration: Seconds for one full spinner cycle. Default: `1`.
	    - shape: The progress shape. Default: ``Shape/circular``.
	 */
	public init(
		size: ProgressSize = .large,
		trackColor: Color = .black,
		trackWidth: CGFloat? = nil,
		progressColor: Color = .green,
		animationMaxValue: CGFloat? = 0.03,
		animation: Animation = .easeInOut(duration: 0.5),
		innerProgressWidth: CGFloat? = nil,
		innerProgressColor: Color? = .black.opacity(0.2),
		isRounded: Bool = true,
		isClockwise: Bool = true,
		growFrom: GrowDirection = .end,
		isSpinner: Bool = false,
		spinnerCycleDuration: TimeInterval = 1,
		shape: Shape = .circular
	) {
		self.size = size
		self.trackColor = trackColor
		self.trackWidth = trackWidth
		self.progressColor = progressColor
		self.animationMaxValue = animationMaxValue
		self.animation = animation
		self.innerProgressWidth = innerProgressWidth
		self.innerProgressColor = innerProgressColor
		self.isRounded = isRounded
		self.isClockwise = isClockwise
		self.growFrom = growFrom
		self.isSpinner = isSpinner
		self.spinnerCycleDuration = spinnerCycleDuration
		self.shape = shape
	}

	/**
	 The size of the circle.
	 
	 Default: ``ProgressSize/large``.
	 
	 ``ProgressSize/large`` > ``trackWidth`` `= 45`,  ``progressLineWidth`` `= 10`,  ``progressInnerLineWidth`` `= 5`,   ``radius`` `= 60`
	 
	 ``ProgressSize/small`` > ``trackWidth`` = `15`,  ``progressLineWidth`` `= 5`,  ``progressInnerLineWidth`` `= 2.5`,  ``radius`` `= 30`
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setSize(_:)``.
	 */
	public var size: ProgressSize = .large
	
	/**
	 The color of the empty progress track.
	 
	 Default: `Color.black`.
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setTrackColor(_:)``.
	 */
	public var trackColor: Color = .black
	
	/**
	 The width of the empty progress track.
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setTrackWidth(_:)``.
	 */
	public var trackWidth: CGFloat? = nil
	
	/**
	 The progress color.
	 
	 Default: `Color.green`.
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setProgressColor(_:)``.
	 */
	public var progressColor: Color = .green
	
	/**
	 The maximum value for animating progress growth.
	 
	 Default: `0.03`
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setAnimationMaxValue(_:)``. Setting this to `nil` **disables the growing animation in the beginning of the animation**.
	 */
	public var animationMaxValue: CGFloat? = 0.03
	
	/**
	 The animation to use for animating the progress bar.
	 
	 Default: `Animation.easeInOut(duration: 0.5)`.
	 
	 > This is a closure that returns an `Animation`. You can set it to a static animation (e.g. `{ .easeInOut(duration: 0.5) }`) or a dynamic closure that returns a different animation each time it is called. This enables dynamic animation strategies, such as random or state-dependent animations.
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setAnimation(_:)``.
	 */
	public var animation: Animation = .easeInOut(duration: 0.5)
	
	/**
	 The width of the inner progress.
	 
	 Default: `2.5 for` ``ProgressSize/small`` and `5 for` ``ProgressSize/large``.
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setInnerProgressWidth(_:)``.
	 */
	public var innerProgressWidth: CGFloat? = nil
	
	/**
	 Determines the inner progress path's color.
	 
	 Default: `Color.black.opacity(0.2)`.
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setInnerProgressColor(_:)``.
	 */
	public var innerProgressColor: Color? = .black.opacity(0.2)
	
	/**
	 Determines if the progress track is rounded.
	 
	 Default: `true`.
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setIsRounded(_:)``.
	 */
	public var isRounded: Bool = true
	
	/**
	 Determines whether the progress spinning animation should be clockwise.
	 
	 Default: `true`.
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setIsSpinner(_:isClockwise:)``.
	 */
	public var isClockwise: Bool = true
	
	/**
	 Determines where the growing animation should go.
	 
	 Default: ``ProgressUI/GrowDirection/end.
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setGrow(from:)``.
	 */
	public var growFrom: GrowDirection = .end
	
	//MARK: - Spinner
	/**
	 Determines whether the progress animation should spin.
	 
	 Default: `false`.
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setIsSpinner(_:isClockwise:)``.
	 */
	public var isSpinner: Bool = false
	
	/**
	 The spinner duration in seconds for a full spin cycle.
	 
	 Default: `1`.
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setSpinnerCycleDuration(_:)``.
	 */
	public var spinnerCycleDuration: TimeInterval = 1
	
	/**
	 The progress shape..
	 
	 Default: ``ProgressUI/Shape/circular``.
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setShape(_:)``.
	 */
	public var shape: Shape = .circular
}
