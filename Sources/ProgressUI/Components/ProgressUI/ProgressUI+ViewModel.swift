//
//  ProgressUI+ViewModel.swift
//  ProgressUI
//
//  Created by Pierre Janineh on 13/05/2025.
//

import SwiftUI

internal extension ProgressUI {
	final class ViewModel: ObservableObject {
		
		private let minTimerInterval: TimeInterval = 1.0 / 60.0  // 60 FPS target
		
		@Published internal var timer: Timer.TimerPublisher = Timer.publish(every: 0.2, on: .main, in: .common)
		@Published internal var timerTriggered: Bool = false
		@Published internal var width: CGFloat = .zero
		@Published internal var pixelsPerStep: CGFloat = .zero
		
		func setSpinnerIfNeeded(_ options: Options) {
			guard options.isSpinner,
				  options.spinnerCycleDuration > 0
			else { return }
			
			let fullCycle: CGFloat = switch options.shape {
				case .circular: 360
				case .linear( _): width
			}
			
			let pixelsPerTick = fullCycle * (minTimerInterval / options.spinnerCycleDuration)
			
			guard pixelsPerTick > 0 else { return }
			
			pixelsPerStep = pixelsPerTick
			
			timer = Timer.publish(
				every: minTimerInterval,
				on: .main,
				in: .common
			)
			_ = timer.connect()
		}
	}
}
