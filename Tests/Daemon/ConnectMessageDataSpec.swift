//
//  ConnectMessageDataSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class ConnectMessageDataSpec: XCTestCase {
    
    func test_GIVEN_ConnectMessageData_WHEN_rawValue_THEN_shouldReturnEncodedValue() {
        XCTAssert(
			ConnectMessageData(
				deviceID: 3,
				port: 1234
			).rawValue.count > 0
		)
    }
    
}
