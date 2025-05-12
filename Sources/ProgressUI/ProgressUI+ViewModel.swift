//
//  ProgressUI+ViewModel.swift
//  ProgressUI
//
//  Created by Pierre Janineh on 09/05/2025.
//

import SwiftUI

extension ProgressUI {
	/// Internal view model for ProgressUI, managing configuration and state.
	@MainActor
	internal final class ViewModel: ObservableObject {
		/// The current progress value (0...1).
		@Published public var progress: CGFloat = 0
		/// The size of the progress indicator.
		@Published public var size: () -> ProgressSize = { .large }
		/// The color of the track (background circle).
		@Published public var trackColor: () -> Color = { .black }
		/// The width of the track (background circle).
		@Published public var trackWidth: () -> CGFloat? = { nil }
		/// The color of the progress arc.
		@Published public var progressColor: () -> Color = { .green }
		/// The maximum value for the animated width effect at the start of progress.
		@Published public var animationMaxValue: () -> CGFloat? = { 0.03 }
		/// The animation for the progress arc.
		///
		/// > This is a closure that returns an `Animation`. You can set it to a static animation (e.g. `{ .easeInOut(duration: 0.5) }`) or a dynamic closure that returns a different animation each time it is called. This enables dynamic animation strategies, such as random or state-dependent animations.
		@Published public var animation: () -> Animation = { .easeInOut(duration: 0.5) }
		/// The width of the inner progress arc.
		@Published public var innerProgressWidth: () -> CGFloat? = { nil }
		/// The color of the inner progress arc.
		@Published public var innerProgressColor: () -> Color? = { .black.opacity(0.2) }
		/// Whether the progress arc should have rounded line caps.
		@Published public var isRounded: () -> Bool = { true }
		/// Whether the progress arc should be drawn clockwise.
		@Published public var isClockwise: () -> Bool = { true }
		// MARK: - Spinner
		/// Whether the progress indicator should spin (spinner mode).
		@Published public var isSpinner: () -> Bool = { false }
		/// The duration for a full spinner cycle in seconds.
		@Published public var spinnerCycleDuration: () -> TimeInterval = { 1 }
		// MARK: - Options
		/// Applies the given options to the view model.
		/// - Parameter options: The options to apply.
		public func handle(_ options: Options?) {
			guard let options else { return }
			size = options.size
			trackColor = options.trackColor
			trackWidth = options.trackWidth
			progressColor = options.progressColor
			animationMaxValue = options.animationMaxValue
			innerProgressWidth = options.innerProgressWidth
			innerProgressColor = options.innerProgressColor
			isRounded = options.isRounded
			isClockwise = options.isClockwise
			isSpinner = options.isSpinner
			spinnerCycleDuration = options.spinnerCycleDuration
		}
	}
}
