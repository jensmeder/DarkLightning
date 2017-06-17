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
        XCTAssert(
			NetworkUInt32(
				origin: 12,
				byteOrder: Int32(OSLittleEndian)
			).rawValue != UInt32(12)
		)
    }
    
    func test_GIVEN_NetworkUInt32WithBigEndian_WHEN_rawValue_THEN_returnOriginValue() {
        XCTAssert(
			NetworkUInt32(
				origin: 12,
				byteOrder: Int32(OSBigEndian)
			).rawValue == UInt32(12)
		)
    }
}
