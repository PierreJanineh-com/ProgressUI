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
	
	var body: some View {
		Grid {
			GridRow {
				ProgressUI(progress: 0.2)
					.setTrackWidth(20)
#if os(watchOS)
					.setSize(.small)
#endif
				
				ProgressUI(progress: 0.5)
					.setSize(.small)
				
				ProgressUI(progress: 0.3)
					.setProgressColor(.red.opacity(0.5))
					.setInnerProgressColor(.red)
					.setTrackColor(.yellow)
					.setIsClockwise(false)
#if os(watchOS)
					.setSize(.small)
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
					.setAnimationMaxValue(0.5)
					.onReceive(loadingTimer) { _ in
						if loadingProgress >= 1 {
							loadingProgress = 0
							return
						}
						loadingProgress += 0.1
					}
				
				ProgressUI(progress: 0.01)
					.setProgressColor(.yellow.opacity(0.5))
					.setInnerProgressColor(.yellow)
					.setTrackColor(.cyan)
					.setIsSpinner()
					.setSpinnerCycleDuration(2)
					.setIsClockwise(false)
#if os(watchOS)
					.setSize(.small)
#endif
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


enum Status: CaseIterable, Progressable {
	case Excellent
	case Normal
	case SemiNormal
	case Bad
	case Critical
	case Danger
	
	/**
	 Get status color.
	 */
	var color: Color {
		return switch(self){
			case .Excellent:	.green.opacity(0.5)
			case .Normal:		.yellow.opacity(0.5)
			case .SemiNormal:	.orange.opacity(0.5)
			case .Bad:			.red.opacity(0.5)
			case .Critical:		.purple.opacity(0.5)
			case .Danger:		.black.opacity(0.5)
		}
	}
	
	/**
	 Get status color.
	 */
	var innerColor: Color? {
		return switch(self){
			case .Excellent:	.green
			case .Normal:		.yellow
			case .SemiNormal:	.orange
			case .Bad:			.red
			case .Critical:		.purple
			case .Danger:		.black
		}
	}
	
	/**
	 Static func to get instance of enum by providing progress
	 - Parameters:
	   - progress: CGFloat (0.0 - 1.0) progress percentage in decimal.
	 */
	static func calculate(from progress: CGFloat) -> Status {
		let level: CGFloat = CGFloat(1) / CGFloat(Status.allCases.count)
		
		return switch progress {
			case 0...level:						Excellent
			case level...(level * 2): 			Normal
			case (level * 2)...(level * 3):		SemiNormal
			case (level * 3)...(level * 4):		Bad
			case (level * 4)...(level * 5):		Critical
			default:							Danger
		}
	}
}
