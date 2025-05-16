// The Swift Programming Language
// https://docs.swift.org/swift-book
//
//  CircularProgress.swift
//  ProgressUI
//
//  Created by Pierre Janineh on 19/06/2023.
//

import SwiftUI
import Combine

internal struct CircularProgress: View, BaseProgress {
	@EnvironmentObject private var vm: ProgressUI.ViewModel
	
	/// The main progress value, either bound or constant.
	@Binding internal var progress: CGFloat
	
	/// The options for Progress' configurations
	internal var options: Options
	
	/// The type used for dynamic coloring/status.
	internal let statusType: (any CaseIterableAndProgressable.Type)?
	
	/// The current rotation angle for spinner animation.
	@State private var rotationAngle: Angle = .zero
	
	/**
	 Creates a progress indicator with adaptable coloring and updating progress value.
	 - Parameters:
	    - progress: The binding object of the progress updates (0...1).
	    - options: Options for customizing the progress (see ``Options``).
	    - statusType: The ``Progressable`` & `CaseIterable` type to use for dynamic coloring.
	 
	 ## Example
	 ```swift
	 ProgressUI(
	    progress: $progress,
	    options: .init(isRounded: true),
	    statusType: CompletionStatus.self
	 )
	 ```
	 */
	internal init<Status: CaseIterable & Progressable>(
		progress: Binding<CGFloat>,
		options: Options? = nil,
		statusType: Status.Type
	) {
		self._progress = progress
		self.options = options ?? Options()
		self.statusType = statusType
	}
	
	/**
	 Creates a progress indicator with updating progress value.
	 - Parameters:
	    - progress: The binding object of the progress updates (0...1).
	    - options: Options for customizing the progress (see ``Options``).
	 
	 ## Example
	 ```swift
	 ProgressUI(
	    progress: $progress,
	    options: .init(isRounded: true)
	 )
	 ```
	 */
	internal init(
		progress: Binding<CGFloat>,
		options: Options? = nil
	) {
		self._progress = progress
		self.options = options ?? Options()
		self.statusType = nil
	}
	
	internal var body: some View {
		GeometryReader { geometry in
			ZStack {
				let path = Path { path in
					let maxStrokeWidth = max(trackWidth, innerProgressWidth)
					let totalWidth: CGFloat = min(geometry.size.width, geometry.size.height)
					let availableWidth = totalWidth - (maxStrokeWidth * 2)
					let center = CGPoint(x: totalWidth / 2, y: totalWidth / 2)
					let radius = (availableWidth / 2) + (maxStrokeWidth / 2)
					
					path.addRelativeArc(
						center: center,
						radius: radius,
						startAngle: startAngle,
						delta: delta
					)
				}
				
				//MARK: - Track
				path
					.stroke(trackColor, style: StrokeStyle(lineWidth: trackWidth))
				
				//MARK: - Progress
				path
					.trim(from: start, to: end)
					.stroke(
						color,
						style: StrokeStyle(
							lineWidth: (
								progress > (options.animationMaxValue ?? 0) ?
								trackWidth :
									animatedWidth(progress)
							),
							lineCap: options.isRounded ? .round : .butt
						)
					)
					.rotationEffect(rotationAngle)
				
				//MARK: - Inner
				if let innerColor {
					path
						.trim(from: start, to: end)
						.stroke(
							innerColor,
							style: StrokeStyle(
								lineWidth: innerProgressWidth,
								lineCap: options.isRounded ? .round : .butt
							)
						)
						.rotationEffect(rotationAngle)
				}
			}
		}
		.aspectRatio(1, contentMode: .fit)
		.onChange(of: vm.timerTriggered) { _ in
			if rotationAngle.degrees >= 360 || rotationAngle.degrees <= -360 {
				rotationAngle = .degrees(0)
				return
			}
			
			if options.isClockwise {
				rotationAngle = .degrees(rotationAngle.degrees + vm.pixelsPerStep)
			} else {
				rotationAngle = .degrees(rotationAngle.degrees - vm.pixelsPerStep)
			}
		}
	}
	
	private var startAngle: Angle {
		switch options.growFrom {
			case .start, .end: .degrees(-90)
			case .center: .degrees(90)
		}
	}
	
	private var delta: Angle {
		let degrees: Double = switch options.growFrom {
			case .start: -360
			case .end, .center: 360
		}
		return Angle(degrees: degrees)
	}
	
	private var start: CGFloat {
		switch options.growFrom {
			case .start, .end:
				return 0
			case .center:
				let mid: CGFloat = 0.5
				let half = progress / 2
				return (mid - half).clamped(to: 0...1)
		}
	}
	
	private var end: CGFloat {
		switch options.growFrom {
			case .start, .end:
				return progress
			case .center:
				let mid: CGFloat = 0.5
				let half = progress / 2
				return (mid + half).clamped(to: 0...1)
		}
	}
}
