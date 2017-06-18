//
//  DictDataSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class DictDataSpec: XCTestCase {
    
    func test_GIVEN_DictData_WHEN_rawValue_THEN_shouldReturnEncodedValue() {
        XCTAssert(
			DictData().dataValue.count > 0
		)
    }
    
}
