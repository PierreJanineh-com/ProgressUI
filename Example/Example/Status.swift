//
//  Status.swift
//  Example
//
//  Created by Pierre Janineh on 16/05/2025.
//

import SwiftUI
import ProgressUI

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
			case .Excellent:	.green.opacity(0.8)
			case .Normal:		.yellow.opacity(0.8)
			case .SemiNormal:	.orange.opacity(0.8)
			case .Bad:			.red.opacity(0.8)
			case .Critical:		.purple.opacity(0.8)
			case .Danger:		.black.opacity(0.8)
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
