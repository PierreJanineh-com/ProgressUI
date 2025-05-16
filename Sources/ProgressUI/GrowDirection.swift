//
//  GrowDirection.swift
//  ProgressUI
//
//  Created by Pierre Janineh on 16/05/2025.
//

import SwiftUI

/// The progress' growing direction.
@frozen
public enum GrowDirection {
	/// Grows from start (leading)
	case start
	/// Grows from center (perfect for spinners)
	case center
	/// Grows from end (trailing)
	case end
	
	internal var alignment: Alignment { switch self {
		case .start: .leading
		case .center: .center
		case .end: .trailing
	}}
}
