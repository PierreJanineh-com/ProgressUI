//
//  ProgressUI+Modifiers.swift
//  ProgressUI
//
//  Created by Pierre Janineh on 09/05/2025.
//

import SwiftUI

extension ProgressUI {
	/// Sets the size of the progress indicator.
	/// - Parameter size: The desired size (small or large).
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: ``ProgressSize/large``.
	///
	/// ``ProgressSize/large`` > ``trackWidth`` `= 45`,  ``progressLineWidth`` `= 10`,  ``progressInnerLineWidth`` `= 5`,   ``radius`` `= 60`
	///
	/// ``ProgressSize/small`` > ``trackWidth`` = `15`,  ``progressLineWidth`` `= 5`,  ``progressInnerLineWidth`` `= 2.5`,  ``radius`` `= 30`
	public func setSize(_ size: ProgressSize) -> Self {
		vm.size = { size }
		return self
	}

	/// Sets the size of the progress indicator dynamically.
	/// - Parameter size: A closure that returns the desired size (small or large).
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: ``ProgressSize/large``.
	///
	/// > This overload allows for dynamic sizing strategies. The closure will be called each time the size is needed, so you can return a different size each time (e.g. based on state, environment, etc).
	public func setSize(_ size: @escaping () -> ProgressSize) -> Self {
		vm.size = size
		return self
	}
	
	/// Sets the color of the track (background circle).
	/// - Parameter color: The desired track color.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `Color.black`.
	public func setTrackColor(_ color: Color) -> Self {
		vm.trackColor = { color }
		return self
	}

	/// Sets the color of the track (background circle) dynamically.
	/// - Parameter color: A closure that returns the desired track color.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `Color.black`.
	///
	/// > This overload allows for dynamic coloring strategies. The closure will be called each time the color is needed, so you can return a different color each time (e.g. based on progress, theme, etc).
	public func setTrackColor(_ color: @escaping () -> Color) -> Self {
		vm.trackColor = color
		return self
	}
	
	/// Sets the width of the track (background circle).
	/// - Parameter width: The desired track width.
	/// - Returns: A modified ProgressUI instance.
	public func setTrackWidth(_ width: CGFloat) -> Self {
		vm.trackWidth = { width }
		return self
	}

	/// Sets the width of the track (background circle) dynamically.
	/// - Parameter width: A closure that returns the desired track width.
	/// - Returns: A modified ProgressUI instance.
	///
	/// > This overload allows for dynamic width strategies. The closure will be called each time the width is needed, so you can return a different width each time (e.g. based on size, state, etc).
	public func setTrackWidth(_ width: @escaping () -> CGFloat) -> Self {
		vm.trackWidth = { width() }
		return self
	}
	
	/// Sets the color of the progress arc.
	/// - Parameter color: The desired progress color.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `Color.green`.
	public func setProgressColor(_ color: Color) -> Self {
		vm.progressColor = { color }
		return self
	}

	/// Sets the color of the progress arc dynamically.
	/// - Parameter color: A closure that returns the desired progress color.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `Color.green`.
	///
	/// > This overload allows for dynamic coloring strategies. The closure will be called each time the color is needed, so you can return a different color each time (e.g. based on progress, state, etc).
	public func setProgressColor(_ color: @escaping () -> Color) -> Self {
		vm.progressColor = color
		return self
	}
	
	/// Sets the maximum value for the animated width effect at the start of progress.
	/// - Parameter value: The maximum value for animation.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `0.03`.
	///
	/// > Setting this to `nil` **disables the growing animation in the beginning of the animation**.
	public func setAnimationMaxValue(_ value: CGFloat?) -> Self {
		vm.animationMaxValue = { value }
		return self
	}

	/// Sets the maximum value for the animated width effect at the start of progress dynamically.
	/// - Parameter value: A closure that returns the maximum value for animation.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `0.03`.
	///
	/// > This overload allows for dynamic animation max value strategies. The closure will be called each time the value is needed, so you can return a different value each time (e.g. based on state, progress, etc).
	public func setAnimationMaxValue(_ value: @escaping () -> CGFloat?) -> Self {
		vm.animationMaxValue = value
		return self
	}
	
	/// Sets the animation for the progress arc.
	/// - Parameter animation: The desired animation.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `Animation.easeInOut(duration: 0.5)`.
	///
	/// > This overload is for static animation. If you want dynamic animation (e.g. random or state-dependent), use the closure overload below.
	public func setAnimation(_ animation: Animation) -> Self {
		vm.animation = { animation }
		return self
	}
	
	/// Sets the animation for the progress arc.
	/// - Parameter animation: A closure that returns the desired animation.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `Animation.easeInOut(duration: 0.5)`.
	///
	/// > This overload allows for dynamic animation strategies. The closure will be called each time an animation is needed, so you can return a different animation each time (e.g. random, state-dependent, etc).
	public func setAnimation(_ animation: @escaping () -> Animation) -> Self {
		vm.animation = animation
		return self
	}
	
	/// Sets the width of the inner progress arc.
	/// - Parameter width: The desired inner progress width.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `2.5 for` ``ProgressSize/small`` and `5 for` ``ProgressSize/large``.
	public func setInnerProgressWidth(_ width: CGFloat) -> Self {
		vm.innerProgressWidth = { width }
		return self
	}

	/// Sets the width of the inner progress arc dynamically.
	/// - Parameter width: A closure that returns the desired inner progress width.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `2.5 for` ``ProgressSize/small`` and `5 for` ``ProgressSize/large``.
	///
	/// > This overload allows for dynamic width strategies. The closure will be called each time the width is needed, so you can return a different width each time (e.g. based on size, state, etc).
	public func setInnerProgressWidth(_ width: @escaping () -> CGFloat) -> Self {
		vm.innerProgressWidth = { width() }
		return self
	}
	
	/// Sets the color of the inner progress arc.
	/// - Parameter color: The desired inner progress color.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `Color.black.opacity(0.2)`.
	public func setInnerProgressColor(_ color: Color?) -> Self {
		vm.innerProgressColor = { color }
		return self
	}

	/// Sets the color of the inner progress arc dynamically.
	/// - Parameter color: A closure that returns the desired inner progress color.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `Color.black.opacity(0.2)`.
	///
	/// > This overload allows for dynamic coloring strategies. The closure will be called each time the color is needed, so you can return a different color each time (e.g. based on progress, state, etc).
	public func setInnerProgressColor(_ color: @escaping () -> Color?) -> Self {
		vm.innerProgressColor = color
		return self
	}
	
	/// Sets whether the progress arc should have rounded line caps.
	/// - Parameter isRounded: Whether to use rounded line caps (default: true).
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `true`.
	public func setIsRounded(_ isRounded: Bool = true) -> Self {
		vm.isRounded = { isRounded }
		return self
	}

	/// Sets whether the progress arc should have rounded line caps dynamically.
	/// - Parameter isRounded: A closure that returns whether to use rounded line caps.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `true`.
	///
	/// > This overload allows for dynamic strategies. The closure will be called each time the value is needed, so you can return a different value each time (e.g. based on state, progress, etc).
	public func setIsRounded(_ isRounded: @escaping () -> Bool) -> Self {
		vm.isRounded = isRounded
		return self
	}
	
	/// Sets whether the progress arc should be drawn clockwise.
	/// - Parameter isClockwise: Whether to draw clockwise (default: true).
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `true`.
	public func setIsClockwise(_ isClockwise: Bool = true) -> Self {
		vm.isClockwise = { isClockwise }
		return self
	}

	/// Sets whether the progress arc should be drawn clockwise dynamically.
	/// - Parameter isClockwise: A closure that returns whether to draw clockwise.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `true`.
	///
	/// > This overload allows for dynamic strategies. The closure will be called each time the value is needed, so you can return a different value each time (e.g. based on state, progress, etc).
	public func setIsClockwise(_ isClockwise: @escaping () -> Bool) -> Self {
		vm.isClockwise = isClockwise
		return self
	}
	
	/// Sets whether the progress indicator should spin (spinner mode).
	/// - Parameter isSpinner: Whether to enable spinner mode (default: true).
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `false`.
	public func setIsSpinner(_ isSpinner: Bool = true) -> Self {
		vm.isSpinner = { isSpinner }
		return self
	}

	/// Sets whether the progress indicator should spin (spinner mode) dynamically.
	/// - Parameter isSpinner: A closure that returns whether to enable spinner mode.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `false`.
	///
	/// > This overload allows for dynamic strategies. The closure will be called each time the value is needed, so you can return a different value each time (e.g. based on state, progress, etc).
	public func setIsSpinner(_ isSpinner: @escaping () -> Bool) -> Self {
		vm.isSpinner = isSpinner
		return self
	}
	
	/// Sets the duration for a full spinner cycle.
	/// - Parameter duration: The spinner cycle duration in seconds.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `1`.
	public func setSpinnerCycleDuration(_ duration: TimeInterval) -> Self {
		vm.spinnerCycleDuration = { duration }
		return self
	}

	/// Sets the duration for a full spinner cycle dynamically.
	/// - Parameter duration: A closure that returns the spinner cycle duration in seconds.
	/// - Returns: A modified ProgressUI instance.
	///
	/// Default: `1`.
	///
	/// > This overload allows for dynamic strategies. The closure will be called each time the value is needed, so you can return a different value each time (e.g. based on state, progress, etc).
	public func setSpinnerCycleDuration(_ duration: @escaping () -> TimeInterval) -> Self {
		vm.spinnerCycleDuration = duration
		return self
	}
}
