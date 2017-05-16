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
        // GIVEN
        let data = ListeningMessageData()
        
        // WHEN
        let result = data.rawValue
        
        // THEN
        XCTAssert(result.count > 0)
    }
    
}
