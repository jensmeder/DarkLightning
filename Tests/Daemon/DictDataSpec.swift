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
        // GIVEN
        let data = DictData(dict: [:])
        
        // WHEN
        let result = data.rawValue
        
        // THEN
        XCTAssert(result.count > 0)
    }
    
}
