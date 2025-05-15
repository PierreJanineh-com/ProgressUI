//
//  LinearProgress.swift
//  ProgressUI
//
//  Created by Pierre Janineh on 13/05/2025.
//

import SwiftUI
import Combine

internal struct LinearProgress: View, BaseProgress {
	@EnvironmentObject private var vm: ProgressUI.ViewModel
	
	/// The main progress value, either bound or constant.
	@Binding internal var progress: CGFloat
	
	/// The options for Progress' configurations
	internal var options: Options
	
	/// The type used for dynamic coloring/status.
	internal let statusType: (any CaseIterableAndProgressable.Type)?
	
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
	
	private var cornerRadius: CGFloat {
		options.isRounded ? trackWidth / 2 : 0
	}
	
	@ViewBuilder
	private var BaseShape: RoundedRectangle {
		RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
	}
	
	/// The current X translation for spinner animation.
	@State private var translationX: CGFloat = .zero
	
	internal var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				//MARK: - Track
				BaseShape
					.fill(trackColor)
					.frame(width: geometry.size.width, height: trackWidth)
				
				//MARK: - Progress
				BaseShape
					.fill(color)
					.frame(
						width: geometry.size.width * progress,
						height: progress > (options.animationMaxValue ?? 0) ?
						trackWidth :
							animatedWidth(progress)
					)
					.transformEffect(.init(translationX: translationX, y: 0))
				
				//MARK: - Inner
				if case .linear(let hPadding) = options.shape,
				   let innerColor {
					BaseShape
						.fill(innerColor)
						.frame(
							width: (geometry.size.width * progress) - (hPadding * 2),
							height: innerProgressWidth
						)
						.padding(.leading, hPadding)
						.transformEffect(.init(translationX: translationX, y: 0))
				}
			}
			.frame(
				maxWidth: .infinity,
				maxHeight: .infinity,
				alignment: .center
			)
			.mask(
				BaseShape.frame(width: geometry.size.width, height: trackWidth)
			)
			.onChange(of: vm.timerTriggered) { _ in
				if translationX >= geometry.size.width {
					translationX = -(progress * geometry.size.width)
				}
				
				if options.isClockwise {
					translationX += vm.pixelsPerStep
				} else {
					translationX -= vm.pixelsPerStep
				}
			}
			.onAppear {
				translationX = -(progress * geometry.size.width)
				vm.width = geometry.size.width
			}
		}
	}
}
