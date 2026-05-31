//
//  GrowDirectionTests.swift
//  ProgressUI
//
//  Created by Pierre Janineh on 30/05/2026.
//

import XCTest
import SwiftUI
@testable import ProgressUI

final class GrowDirectionTests: XCTestCase {

	/// `alignment` is the internal bridge GrowDirection uses to position the growing arc;
	/// each case must map to the matching SwiftUI alignment.
	func testAlignmentMapping() {
		XCTAssertEqual(GrowDirection.start.alignment, .leading)
		XCTAssertEqual(GrowDirection.center.alignment, .center)
		XCTAssertEqual(GrowDirection.end.alignment, .trailing)
	}
}
