// The Swift Programming Language
// https://docs.swift.org/swift-book
//
//  ProgressUI.swift
//  StorageAnalysis
//
//  Created by Pierre Janineh on 19/06/2023.
//

import SwiftUI
import Combine

private typealias CaseIterableAndProgressable = CaseIterable & Progressable

/**
 A highly customizable and animated circular progress indicator for SwiftUI.
 
 `ProgressUI` supports dynamic coloring, spinner mode, multiple sizes, and easy appearance customization.
 Use it to display progress, loading, or status indicators in your SwiftUI apps.
 
 ## Features
 - Dynamic coloring based on progress state
 - Spinner (indeterminate) mode
 - Multiple size presets (small/large)
 - Customizable track/progress/inner colors
 - Adjustable stroke widths and line caps
 - Smooth animations (static or dynamic)
 - Unified API for both binding and static progress
 
 ## Basic Usage
 ```swift
 import ProgressUI
 
 struct ContentView: View {
    @State private var progress: CGFloat = 0.5
    var body: some View {
        ProgressUI(progress: $progress)
    }
 }
 ```
 
 ## Dynamic Coloring Example
 ```swift
 enum StorageStatus: CaseIterable, Progressable {
     case safe, warning, critical, full
     var color: Color {
         switch self {
             case .safe: .green
             case .warning: .yellow
             case .critical: .orange
             case .full: .red
         }
     }
     static func calculate(from progress: CGFloat) -> StorageStatus {
         switch progress {
             case 0..<0.25: .safe
             case 0.25..<0.5: .warning
             case 0.5..<0.75: .critical
             default: .full
         }
     }
 }
 
 struct ContentView: View {
     @State private var progress: CGFloat = 0.0
     var body: some View {
         ProgressUI(
             progress: $progress,
             options: .init(isRounded: true),
             statusType: StorageStatus.self
         )
     }
 }
 ```
 
 ## Spinner Example
 ```swift
 ProgressUI(
     progress: .constant(1),
     options: .init(
         isSpinner: true,
         spinnerCycleDuration: 2,
         progressColor: .blue
     )
 )
 ```
 */
public struct ProgressUI: View {
	/// The main progress value, either bound or constant.
	///
	/// If initialized with a binding, this will update as the binding changes. If initialized with a static value, this remains constant.
	@Binding private var progress: CGFloat
	
	/// The options for Progress' configurations
	internal var options: Options
	
	/// The type used for dynamic coloring/status.
	///
	/// Pass a type conforming to both `CaseIterable` and `Progressable` to enable dynamic coloring based on progress.
	private let statusType: (any CaseIterableAndProgressable.Type)?
	
	/// The current rotation angle for spinner animation.
	@State private var rotationAngle: Angle = .zero
	
	/// The timer for spinner animation.
	@State private var timer: Timer.TimerPublisher = Timer.publish(every: 0.2, on: .main, in: .common)
	
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
	public init<Status: CaseIterable & Progressable>(
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
	public init(
		progress: Binding<CGFloat>,
		options: Options? = nil
	) {
		self._progress = progress
		self.options = options ?? Options()
		self.statusType = nil
	}
	
	/**
	 Creates a progress indicator with static progress.
	 - Parameters:
	    - progress: The CGFloat value of the progress (0...1).
	    - options: Options for customizing the progress (see ``Options``).
	 
	 ## Example
	 ```swift
	 ProgressUI(
	    progress: 0.75,
	    options: .init(trackColor: .gray)
	 )
	 ```
	 */
	public init(
		progress: CGFloat,
		options: Options? = nil
	) {
		self._progress = .constant(progress)
		self.options = options ?? Options()
		self.statusType = nil
	}
	
	/**
	 Creates a progress indicator with static progress and adaptable coloring.
	 - Parameters:
	    - progress: The CGFloat value of the progress (0...1).
	    - options: Options for customizing the progress (see ``Options``).
	    - statusType: The ``Progressable`` & `CaseIterable` type to use for dynamic coloring.
	 
	 ## Example
	 ```swift
	 ProgressUI(
	    progress: 0.75,
	    options: .init(trackColor: .gray),
	    statusType: CompletionStatus.self
	 )
	 ```
	 */
	public init<Status: CaseIterable & Progressable>(
		progress: CGFloat,
		options: Options? = nil,
		statusType: Status.Type
	) {
		self._progress = .constant(progress)
		self.options = options ?? Options()
		self.statusType = statusType
	}
	
	public var body: some View {
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
						startAngle: Angle(degrees: -90),
						delta: Angle(degrees: options.isClockwise ? 360 : -360)
					)
				}
				
				//MARK: - Track
				path
					.stroke(trackColor, style: StrokeStyle(lineWidth: trackWidth))
				
				//MARK: - Progress
				path
					.trim(from: 0, to: progress)
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
						.trim(from: 0, to: progress)
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
		.animation(options.animation, value: progress)
		.aspectRatio(1, contentMode: .fit)
		.onAppear {
			setSpinnerIfNeeded()
		}
		.onReceive(timer) { _ in
			if options.isClockwise {
				rotationAngle = .degrees(rotationAngle.degrees + 1)
			} else {
				rotationAngle = .degrees(rotationAngle.degrees - 1)
			}
		}
	}
	
	private func setSpinnerIfNeeded() {
		 guard options.isSpinner else { return }
		 timer = Timer.publish(
			 every: timeIntervalPerDegree,
			 on: .main,
			 in: .common
		 )
		 _ = timer.connect()
	 }
	
	/// The current status for dynamic coloring.
	private var status: (any CaseIterableAndProgressable)? {
		statusType.map { $0.calculate(from: progress) as any CaseIterableAndProgressable }
	}
	
	/// The main progress color.
	private var color: Color {
		status?.color ?? options.progressColor
	}
	
	/// The inner progress color.
	private var innerColor: Color? {
		status?.innerColor ?? options.innerProgressColor
	}
	
	/// The track/background color.
	private var trackColor: Color {
		options.trackColor
	}
	
	/// Determines the width of the track.
	private var trackWidth: CGFloat {
		if let trackWidth = options.trackWidth { return trackWidth }
		
		return switch options.size {
			case .large: 45
			case .small: 15
		}
	}
	
	/// Determines the width of the inner progress.
	private var innerProgressWidth: CGFloat {
		if let innerProgressWidth = options.innerProgressWidth { return innerProgressWidth }
		
		return switch options.size {
			case .large: 5
			case .small: 2.5
		}
	}
	
	/// Animates the width of the progress at the start for a growing effect.
	private func animatedWidth(_ value: CGFloat) -> CGFloat {
		guard let maxValue = options.animationMaxValue else { return trackWidth }
		
		let percentage = (value / maxValue).clamped(to: 0...1)
		return percentage * trackWidth
	}
	
	/// The time interval for each degree of spinner rotation.
	private var timeIntervalPerDegree: TimeInterval {
		options.spinnerCycleDuration / 360
	}
}

/// Utility to clamp values within a range.
private extension Comparable {
	func clamped(to range: ClosedRange<Self>) -> Self {
		min(max(self, range.lowerBound), range.upperBound)
	}
}
