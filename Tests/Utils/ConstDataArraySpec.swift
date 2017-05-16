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
        // GIVEN
        let data = ConstDataArray(values: [])
        
        // WHEN
        let result = data.count
        
        // THEN
        XCTAssert(result == 0)
    }
    
    func test_GIVEN_ConstDataArray_WHEN_count_THEN_returnCount() {
        // GIVEN
        let data = ConstDataArray(data: Data())
        
        // WHEN
        let result = data.count
        
        // THEN
        XCTAssert(result == 1)
    }
    
    func test_GIVEN_ConstDataArray_WHEN_subscript_THEN_returnsObject() {
        // GIVEN
        let data = ConstDataArray(data: Data())
        
        // WHEN
        let result = data[0]
        
        // THEN
        XCTAssertNotNil(result)
    }
    
}
