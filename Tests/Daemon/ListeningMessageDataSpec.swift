//
//  ListeningMessageDataSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class ListeningMessageDataSpec: XCTestCase {
    
    func test_GIVEN_ListeningMessageData_WHEN_rawValue_THEN_shouldReturnEncodedData() {
        XCTAssert(
			ListeningMessageData().dataValue.count > 0
		)
    }
    
}
