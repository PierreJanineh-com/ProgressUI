//
//  OptionsTests.swift
//  ProgressUI
//
//  Created by Pierre Janineh on 30/05/2026.
//

import XCTest
import SwiftUI
@testable import ProgressUI

final class OptionsTests: XCTestCase {

	func testDefaultsMatchDocumentedValues() {
		let options = Options()

		XCTAssertEqual(options.trackColor, .black)
		XCTAssertEqual(options.progressColor, .green)
		XCTAssertEqual(options.animationMaxValue, 0.03)
		XCTAssertNil(options.trackWidth)
		XCTAssertNil(options.innerProgressWidth)
		XCTAssertEqual(options.innerProgressColor, .black.opacity(0.2))
		XCTAssertTrue(options.isRounded)
		XCTAssertTrue(options.isClockwise)
		XCTAssertFalse(options.isSpinner)
		XCTAssertEqual(options.spinnerCycleDuration, 1)

		// GrowDirection / ProgressSize / Shape aren't Equatable — pattern-match instead.
		XCTAssertEqual(options.growFrom.alignment, .trailing) // .end
		guard case .large = options.size else {
			return XCTFail("default size should be .large")
		}
		guard case .circular = options.shape else {
			return XCTFail("default shape should be .circular")
		}
	}

	/// The public memberwise init must let consumers override only the fields they care about.
	func testPublicInitOverridesSelectedFields() {
		let options = Options(
			trackColor: .gray,
			progressColor: .blue,
			isRounded: false,
			growFrom: .center,
			isSpinner: true,
			spinnerCycleDuration: 2
		)

		XCTAssertEqual(options.trackColor, .gray)
		XCTAssertEqual(options.progressColor, .blue)
		XCTAssertFalse(options.isRounded)
		XCTAssertEqual(options.growFrom.alignment, .center)
		XCTAssertTrue(options.isSpinner)
		XCTAssertEqual(options.spinnerCycleDuration, 2)

		// Untouched fields keep their defaults.
		XCTAssertEqual(options.animationMaxValue, 0.03)
		XCTAssertTrue(options.isClockwise)
	}

	func testLinearShapeCarriesPadding() {
		let options = Options(shape: .linear(20))
		guard case .linear(let padding) = options.shape else {
			return XCTFail("expected linear shape")
		}
		XCTAssertEqual(padding, 20)
	}

	func testLinearShapeDefaultPadding() {
		// `Shape` (the package enum) collides with `SwiftUI.Shape`, and the
		// `ProgressUI` type name shadows the module — so reach the value via Options.
		let options = Options(shape: .linear())
		guard case .linear(let padding) = options.shape else {
			return XCTFail("expected linear shape")
		}
		XCTAssertEqual(padding, 15)
	}
}
