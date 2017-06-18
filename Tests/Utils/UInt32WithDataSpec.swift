//
//  UInt32WithDataSpec.swift
//  Tests
//
//  Created by Jens Meder on 18.06.17.
//

import XCTest
@testable import DarkLightning

class UInt32WithDataSpec: XCTestCase {
    
	func test_GIVEN_UInt32WithData_WHEN_rawValue_THEN_returnsUIn32EnclosedInData() {
		XCTAssertTrue(
			UInt32WithData(
				data: RawData(
					Data(
						bytes: [12,0,0,0]
					)
				)
			).rawValue == 12
		)
	}
    
}
