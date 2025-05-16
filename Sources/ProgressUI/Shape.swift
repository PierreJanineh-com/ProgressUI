//
//  Shape.swift
//  ProgressUI
//
//  Created by Pierre Janineh on 13/05/2025.
//

import SwiftUI

/// The shape of the progress.
public enum Shape {
	/// Circular shape
	case circular
	/// Linear shape (progress bar)
	case linear(_ hPadding: CGFloat = 15)
}
