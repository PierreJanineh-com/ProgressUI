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

typealias CaseIterableAndProgressable = CaseIterable & Progressable

public struct ProgressUI: View {
	/// Internal view model handling configuration and state.
	@State internal var vm: ViewModel = .init()
	
	/// The main progress value, either bound or constant.
	@Binding private var progress: CGFloat?
	
	/// The type used for dynamic coloring/status.
	private let statusType: (any CaseIterableAndProgressable.Type)?
	
	/// The current rotation angle for spinner animation.
	@State private var rotationAngle: Angle = .zero
	
	/// The timer for spinner animation.
	@State private var timer: Timer.TimerPublisher = Timer.publish(every: 0.2, on: .main, in: .common)
	
	/**
	 Use this initializer to create a progress indicator with adaptable coloring and updating progress value.
	 
	 - Parameters:
	   - progress: The binding object of the progress updates.
	   - options: Options for customizing the progress.
	   - statusType: The ``Progressable`` & `CaseIterable` type to use for coloring.
	 */
	public init<Status: CaseIterable & Progressable>(
		progress: Binding<CGFloat>,
		options: Options? = nil,
		statusType: Status.Type
	) {
		self._progress = Binding<CGFloat?>(
			get: { progress.wrappedValue },
			set: { progress.wrappedValue = $0 ?? 0 }
		)
		self.statusType = statusType
		vm.handle(options)
	}
	
	/**
	 Use this initializer to create a progress indicator with updating progress value.
	 
	 - Parameters:
	   - progress: The binding object of the progress updates.
	   - options: Options for customizing the progress.
	 */
	public init(
		progress: Binding<CGFloat>,
		options: Options? = nil
	) {
		self._progress = Binding<CGFloat?>(
			get: { progress.wrappedValue },
			set: { progress.wrappedValue = $0 ?? 0 }
		)
		self.statusType = nil
		vm.handle(options)
	}
	
	/**
	 Use this initializer to create a progress indicator with static progress.
	 
	 - Parameters:
	   - progress: The CGFloat value of the progress.
	   - options: Options for customizing the progress.
	 */
	public init(
		progress: CGFloat,
		options: Options? = nil
	) {
		self._progress = .constant(progress)
		self.statusType = nil
		vm.handle(options)
		vm.progress = progress
	}
	
	public var body: some View {
		GeometryReader { geometry in
			ZStack {
				let path = Path { path in
					let width: CGFloat = min(geometry.size.width, geometry.size.height)
					let height = width
					path.addRelativeArc(center: CGPoint(x: width / 2,
														y: height / 2),
										radius: width / 3,
										startAngle: Angle(degrees: -90),
										delta: Angle(degrees: vm.isClockwise ? 360 : -360))
				}
				
				//MARK: - Track
				path
					.stroke(trackColor, style: StrokeStyle(lineWidth: trackWidth(geometry)))
				
				//MARK: - Progress
				path
					.trim(from: 0, to: currentProgress)
					.stroke(
						color,
						style: StrokeStyle(
							lineWidth: (
								currentProgress > vm.animationMaxValue ?? 0 ?
								trackWidth(geometry) :
									animatedWidth(currentProgress, geometry)
							),
							lineCap: vm.isRounded ? .round : .butt
						)
					)
					.rotationEffect(rotationAngle)
				
				//MARK: - Inner
				if let innerColor {
					path
						.trim(from: 0, to: currentProgress)
						.stroke(
							innerColor,
							style: StrokeStyle(
								lineWidth: innerProgressWidth(geometry),
								lineCap: vm.isRounded ? .round : .butt
							)
						)
						.rotationEffect(rotationAngle)
				}
			}
			.animation(vm.animation(), value: currentProgress)
		}
		.aspectRatio(1, contentMode: .fit)
		.onAppear {
			guard vm.isSpinner else { return }
			timer = Timer.publish(
				every: timeIntervalPerDegree,
				on: .main,
				in: .common
			)
			_ = timer.connect()
		}
		.onReceive(timer) { _ in
			if vm.isClockwise {
				rotationAngle = .degrees(rotationAngle.degrees + 1)
			} else {
				rotationAngle = .degrees(rotationAngle.degrees - 1)
			}
		}
	}
	
	/// Unified accessor for the current progress value (binding or static).
	private var currentProgress: CGFloat {
		progress ?? vm.progress
	}
	
	/// The current status for dynamic coloring.
	private var status: (any CaseIterableAndProgressable)? {
		statusType?.calculate(from: progress ?? vm.progress)
	}
	
	/// The main progress color.
	private var color: Color {
		status?.color ?? vm.progressColor
	}
	
	/// The inner progress color.
	private var innerColor: Color? {
		status?.innerColor ?? vm.innerProgressColor
	}
	
	/// The track/background color.
	private var trackColor: Color {
		vm.trackColor
	}
	
	/// Determines the width of the track.
	private func trackWidth(_ geometry: GeometryProxy) -> CGFloat {
		if let trackWidth = vm.trackWidth { return trackWidth }
		
		return switch vm.size {
			case .large: 45
			case .small: 15
		}
	}
	
	/// Determines the width of the inner progress.
	private func innerProgressWidth(_ geometry: GeometryProxy) -> CGFloat {
		if let innerProgressWidth = vm.innerProgressWidth { return innerProgressWidth }
		
		return switch vm.size {
			case .large: 5
			case .small: 2.5
		}
	}
	
	/// Animates the width of the progress at the start for a growing effect.
	private func animatedWidth(
		_ value: CGFloat,
		_ geometry: GeometryProxy
	) -> CGFloat {
		guard let maxValue = vm.animationMaxValue else { return trackWidth(geometry) }
		
		let percentage = (value / maxValue).clamped(to: 0...1)
		return percentage * trackWidth(geometry)
	}
	
	/// The time interval for each degree of spinner rotation.
	private var timeIntervalPerDegree: TimeInterval {
		return vm.spinnerCycleDuration / 360
	}
}

/// Utility to clamp values within a range.
private extension Comparable {
	func clamped(to range: ClosedRange<Self>) -> Self {
		min(max(self, range.lowerBound), range.upperBound)
	}
}
