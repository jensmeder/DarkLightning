//
//  DataWithUInt32Spec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class DataWithUInt32Spec: XCTestCase {
    
    func test_GIVEN_DataWithUInt32_WHEN_rawValue_THEN_shouldReturnEncodedValue() {
        // GIVEN
        let data = DataWithUInt32(value: 42, origin: OODataFake())
        
        // WHEN
        let result = data.rawValue
        
        // THEN
        XCTAssert(result.count == 4)
    }
    
}
