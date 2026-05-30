//
//  ProgressableTests.swift
//  ProgressUI
//

import XCTest
import SwiftUI
@testable import ProgressUI

/// A four-bucket sample status, mirroring the README's StorageStatus example.
private enum SampleStatus: CaseIterable, Progressable, Equatable {
	case safe, warning, critical, full

	var color: Color {
		switch self {
		case .safe:     return .green
		case .warning:  return .yellow
		case .critical: return .orange
		case .full:     return .red
		}
	}

	var innerColor: Color? { color.opacity(0.4) }

	static func calculate(from progress: CGFloat) -> SampleStatus {
		switch progress {
		case ..<0.25: return .safe
		case ..<0.5:  return .warning
		case ..<0.75: return .critical
		default:      return .full
		}
	}
}

/// A status that omits `innerColor` to exercise the protocol's default implementation.
private enum MinimalStatus: CaseIterable, Progressable, Equatable {
	case low, high

	var color: Color { self == .low ? .green : .red }

	static func calculate(from progress: CGFloat) -> MinimalStatus {
		progress < 0.5 ? .low : .high
	}
}

final class ProgressableTests: XCTestCase {

	func testCalculateBuckets() {
		XCTAssertEqual(SampleStatus.calculate(from: 0), .safe)
		XCTAssertEqual(SampleStatus.calculate(from: 0.24), .safe)
		XCTAssertEqual(SampleStatus.calculate(from: 0.25), .warning)
		XCTAssertEqual(SampleStatus.calculate(from: 0.49), .warning)
		XCTAssertEqual(SampleStatus.calculate(from: 0.5), .critical)
		XCTAssertEqual(SampleStatus.calculate(from: 0.74), .critical)
		XCTAssertEqual(SampleStatus.calculate(from: 0.75), .full)
		XCTAssertEqual(SampleStatus.calculate(from: 1), .full)
	}

	/// Out-of-range values fall through to the final bucket rather than trapping.
	func testCalculateClampsBeyondRange() {
		XCTAssertEqual(SampleStatus.calculate(from: 5), .full)
	}

	func testInnerColorDefaultsToNil() {
		XCTAssertNil(MinimalStatus.low.innerColor)
		XCTAssertNil(MinimalStatus.high.innerColor)
	}

	func testInnerColorWhenProvided() {
		XCTAssertEqual(SampleStatus.safe.innerColor, Color.green.opacity(0.4))
	}
}
