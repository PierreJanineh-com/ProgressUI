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
	 Determines whether the progress animation should be clockwise.
	 
	 Default: `true`.
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setIsClockwise(_:)``.
	 */
	public var isClockwise: Bool = true
	
	//MARK: - Spinner
	/**
	 Determines whether the progress animation should spin.
	 
	 Default: `false`.
	 
	 > You can set this with the modifier ``ProgressUI/ProgressUI/setIsSpinner(_:)``.
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
