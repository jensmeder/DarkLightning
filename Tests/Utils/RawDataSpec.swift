//
//  RawDataSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class RawDataSpec: XCTestCase {
    
    func test_GIVEN_RawData_WHEN_rawValue_THEN_returnsOriginValue() {
        XCTAssert(
			RawData(
				"Hello World!".data(using: .utf8)!
			).rawValue == "Hello World!".data(using: .utf8)!
		)
    }
    
}
