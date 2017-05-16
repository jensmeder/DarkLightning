//
//  NetworkUInt32Spec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class NetworkUInt32Spec: XCTestCase {
    
    func test_GIVEN_NetworkUInt32WithLittleEndian_WHEN_rawValue_THEN_returnBigEndianValue() {
        // GIVEN
        let rawValue: UInt32 = 12
        let value = NetworkUInt32(origin: rawValue, byteOrder: Int32(OSLittleEndian))
        
        // WHEN
        let result = value.rawValue
        
        // THEN
        XCTAssert(rawValue != result)
    }
    
    func test_GIVEN_NetworkUInt32WithBigEndian_WHEN_rawValue_THEN_returnOriginValue() {
        // GIVEN
        let rawValue: UInt32 = 12
        let value = NetworkUInt32(origin: rawValue, byteOrder: Int32(OSBigEndian))
        
        // WHEN
        let result = value.rawValue
        
        // THEN
        XCTAssert(rawValue == result)
    }
}
