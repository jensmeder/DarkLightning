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
        // GIVEN
        let origin = "Hello World!".data(using: .utf8)!
        let data = RawData(origin)
    
        // WHEN
        let result = data.rawValue
        
        // THEN
        XCTAssert(result == origin)
    }
    
}
