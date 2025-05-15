//
//  ProgressUI.swift
//  ProgressUI
//
//  Created by Pierre Janineh on 19/06/2023.
//

import SwiftUI
import Combine

internal typealias CaseIterableAndProgressable = CaseIterable & Progressable

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
	
	@StateObject private var vm: ViewModel
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
		self._vm = .init(wrappedValue: .init())
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
		self._vm = .init(wrappedValue: .init())
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
		self._vm = .init(wrappedValue: .init())
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
		self._vm = .init(wrappedValue: .init())
	}
	
	public var body: some View {
		Group {
			switch options.shape {
				case .circular: Circular
				case .linear( _): Linear
			}
		}
		.animation(options.animation, value: progress)
		.environmentObject(vm)
		.onReceive(vm.timer) { _ in vm.timerTriggered.toggle() }
		.onAppear { vm.setSpinnerIfNeeded(options) }
	}
	
	@ViewBuilder
	private var Circular: some View {
		if let statusType {
			CircularProgress(
				progress: $progress,
				options: options,
				statusType: statusType
			)
		} else {
			CircularProgress(
				progress: $progress,
				options: options
			)
		}
	}
	
	@ViewBuilder
	private var Linear: some View {
		if let statusType {
			LinearProgress(
				progress: $progress,
				options: options,
				statusType: statusType
			)
		} else {
			LinearProgress(
				progress: $progress,
				options: options
			)
		}
	}
}
