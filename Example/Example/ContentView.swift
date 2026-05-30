//
//  ContentView.swift
//  Example
//
//  Created by Pierre Janineh on 09/05/2025.
//

import SwiftUI
import ProgressUI

extension ContentView {
	final class ViewModel: ObservableObject {
		@Published var value: CGFloat = 0
		
		init() {
			loop()
		}
		
		private func loop() {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
				guard let self else { return }
				self.value = .random(in: 0...1)
				self.loop()
			}
		}
	}
}

struct ContentView: View {
	@StateObject private var vm: ViewModel = .init()
	
	@State private var liveProgress: CGFloat = 0
	let liveTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
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
				
				ProgressUI(progress: vm.value)
					.setSize(.small)
					.setShape(.linear(.zero))
					.setIsRounded(true)
					.setIsSpinner(false)
					.setInnerProgressWidth(8.0)
					.setInnerProgressColor(Color.red)
					.setTrackWidth(8.0)
					.setGrow(from: .start)
					.setTrackColor(.yellow)
					.frame(maxHeight: 8.0)
				
				GeometryReader { geometry in
					ProgressUI(progress: 0.5)
						.setShape(.linear(.zero))
						.setIsSpinner(false)
						.setInnerProgressWidth(0)
						.setProgressColor(.red)
						.setTrackColor(.yellow)
						.setAnimationMaxValue(strokeRatio(forWidth: geometry.size.width))
						.setTrackWidth(8)
				}.frame(height: 8.0)
				
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
	
	/// The 8pt stroke expressed as a fraction of the available width.
	/// Guards against the 0-width GeometryReader reports on first layout.
	private func strokeRatio(forWidth width: CGFloat) -> CGFloat {
		width > 0 ? 8 / width : 0
	}
}

#Preview {
	ContentView()
}
