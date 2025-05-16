//
//  ContentView.swift
//  Example
//
//  Created by Pierre Janineh on 09/05/2025.
//

import SwiftUI
import ProgressUI

struct ContentView: View {
	@State private var liveProgress: CGFloat = 0
	let liveTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	@State private var loadingProgress: CGFloat = 0
	let loadingTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
	
	@State private var spinnerProgress: CGFloat = 0.01
	@State private var isForward: Bool = true
	let spinnerTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
	
	var body: some View {
		Grid {
			GridRow {
				ProgressUI(progress: 0.2)
					.setTrackWidth(20)
#if os(watchOS)
					.setTrackWidth(10)
#endif
				
				ProgressUI(progress: 0.3)
					.setTrackWidth(30)
					.setProgressColor(.red.opacity(0.5))
					.setInnerProgressColor(.red)
					.setTrackColor(.yellow)
					.setGrow(from: .start)
#if os(watchOS)
					.setTrackWidth(12)
#endif
				
				ProgressUI(progress: 0.01)
					.setProgressColor(.yellow.opacity(0.5))
					.setInnerProgressColor(.yellow)
					.setTrackColor(.cyan)
					.setIsSpinner(isClockwise: false)
					.setSpinnerCycleDuration(2)
					.setGrow(from: .start)
#if os(watchOS)
					.setTrackWidth(15)
#endif
			}
			.padding()
			
			GridRow {
				ProgressUI(progress: 0.7)
					.setTrackWidth(20)
					.setInnerProgressWidth(20)
					.setTrackColor(.clear)
					.setInnerProgressColor(.red)
					.setShape(.linear(0))
					.setIsSpinner(isClockwise: false)
#if os(watchOS)
					.setTrackWidth(15)
					.setInnerProgressWidth(15)
#endif
				
				ProgressUI(progress: 0.9)
					.setIsRounded(false)
					.setTrackWidth(50)
					.setInnerProgressWidth(50)
					.setTrackColor(.gray.opacity(0.15))
					.setProgressColor(.teal.opacity(0.3))
					.setInnerProgressColor(.teal)
					.setShape(.linear(0))
					.setGrow(from: .end)
#if os(watchOS)
					.setTrackWidth(15)
					.setInnerProgressWidth(15)
#endif
				
				ProgressUI(progress: 0.6)
					.setTrackWidth(25)
					.setShape(.linear(10))
					.setSpinnerCycleDuration(1)
					.setIsSpinner()
#if os(watchOS)
					.setTrackWidth(15)
					.setInnerProgressWidth(2)
#endif
			}
			.padding()
			
			GridRow {
				GeometryReader { geometry in
					ProgressUI(progress: $liveProgress, statusType: Status.self)
						.setTrackWidth(geometry.size.width * 0.5)
						.setIsRounded(false)
						.setInnerProgressColor(.purple)
						.setTrackColor(.gray.opacity(0.4))
						.setAnimationMaxValue(nil)
						.setAnimation(.bouncy)
						.onReceive(liveTimer) { _ in
							liveProgress = CGFloat.random(in: 0...1)
						}
				}
				.aspectRatio(1, contentMode: .fit)
				
				ProgressUI(progress: $loadingProgress, statusType: Status.self)
					.setTrackWidth(25)
					.setInnerProgressWidth(10)
					.setTrackColor(.black.opacity(0.1))
					.setIsSpinner()
					.setGrow(from: .center)
					.setAnimationMaxValue(1)
#if os(watchOS)
					.setTrackWidth(8)
					.setInnerProgressWidth(4)
#endif
					.onReceive(loadingTimer) { _ in
						// Create a spinner that grows between 0 and 100 continuously
						if loadingProgress >= 1 {
							loadingProgress = 0
							return
						}
						loadingProgress += 0.1
					}
				
				ProgressUI(progress: $spinnerProgress)
					.setTrackWidth(15)
					.setAnimationMaxValue(nil)
					.setTrackColor(.clear)
					.setProgressColor(.black)
					.setIsSpinner(isClockwise: false)
					.setGrow(from: .center)
					.setIsRounded(false)
					.setSpinnerCycleDuration(1)
#if os(watchOS)
					.setTrackWidth(5)
#endif
					.onReceive(spinnerTimer) { _ in
						// Create a spinner that grows between 0.1 and 0.7 continuously
						var progress = spinnerProgress * 100
						let step = 80 / (150 * 0.1)
						if isForward {
							progress += step
						} else if !isForward {
							progress -= step
						}
						spinnerProgress = progress / 100
						
						if progress <= 1 {
							isForward = true
						} else if progress >= 80 {
							isForward = false
						}
					}
			}
			.padding()
		}
		.frame(maxWidth: .infinity, alignment: .center)
		.background(.white)
	}
}

#Preview {
	ContentView()
}
