//
//  BaseProgress.swift
//  ProgressUI
//
//  Created by Pierre Janineh on 13/05/2025.
//

import SwiftUI

/// A protocol that provides common functionality for progress indicators
internal protocol BaseProgress {
	var progress: CGFloat { get }
	var options: Options { get }
	var statusType: (any CaseIterableAndProgressable.Type)? { get }
	
	init<Status: CaseIterable & Progressable>(
		progress: Binding<CGFloat>,
		options: Options?,
		statusType: Status.Type
	)
	
	init(progress: Binding<CGFloat>, options: Options?)
}

extension BaseProgress {
	/// The current status for dynamic coloring.
	var status: (any CaseIterableAndProgressable)? {
		statusType.map { $0.calculate(from: progress) as any CaseIterableAndProgressable }
	}
	
	/// The main progress color.
	var color: Color {
		status?.color ?? options.progressColor
	}
	
	/// The inner progress color.
	var innerColor: Color? {
		status?.innerColor ?? options.innerProgressColor
	}
	
	/// The track/background color.
	var trackColor: Color {
		options.trackColor
	}
	
	/// Determines the width of the track.
	var trackWidth: CGFloat {
		if let trackWidth = options.trackWidth { return trackWidth }
		
		return switch options.size {
			case .large: 45
			case .small: 15
		}
	}
	
	/// Determines the width of the inner progress.
	var innerProgressWidth: CGFloat {
		if let innerProgressWidth = options.innerProgressWidth { return innerProgressWidth }
		
		return switch options.size {
			case .large: 5
			case .small: 2.5
		}
	}
	
	/// Animates the width of the progress at the start for a growing effect.
	func animatedWidth(_ value: CGFloat) -> CGFloat {
		guard let maxValue = options.animationMaxValue else { return trackWidth }
		
		let percentage = (value / maxValue).clamped(to: 0...1)
		return percentage * trackWidth
	}
}

/// Utility to clamp values within a range.
internal extension Comparable {
	func clamped(to range: ClosedRange<Self>) -> Self {
		min(max(self, range.lowerBound), range.upperBound)
	}
}
