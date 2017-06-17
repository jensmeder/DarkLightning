//
//  ConstDataArraySpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class ConstDataArraySpec: XCTestCase {
    
    func test_GIVEN_ConstDataArrayWithNoObjects_WHEN_count_THEN_returnZero() {
        XCTAssert(
			ConstDataArray(
				values: []
			).count == 0
		)
    }
    
    func test_GIVEN_ConstDataArray_WHEN_count_THEN_returnCount() {
        XCTAssert(
			ConstDataArray(
				data: Data()
			).count == 1
		)
    }
    
    func test_GIVEN_ConstDataArray_WHEN_subscript_THEN_returnsObject() {
        XCTAssertNotNil(
			ConstDataArray(
				data: Data()
			)[0]
		)
    }
    
}
