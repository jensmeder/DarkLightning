//
//  NetworkUInt16Spec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class NetworkUInt16Spec: XCTestCase {
    
    func test_GIVEN_NetworkUInt16WithLittleEndian_WHEN_rawValue_THEN_returnBigEndianValue() {
        XCTAssert(
			NetworkUInt16(
				origin: 12,
				byteOrder: Int32(OSLittleEndian)
			).rawValue != UInt16(12)
		)
    }
    
    func test_GIVEN_NetworkUInt16WithBigEndian_WHEN_rawValue_THEN_returnOriginValue() {
        XCTAssert(
			NetworkUInt16(
				origin: 12,
				byteOrder: Int32(OSBigEndian)
			).rawValue == UInt16(12)
		)
    }
    
}
