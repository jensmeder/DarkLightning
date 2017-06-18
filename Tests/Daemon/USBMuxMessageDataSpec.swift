//
//  USBMuxMessageDataSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class USBMuxMessageDataSpec: XCTestCase {
    
    func test_GIVEN_USBMuxMessageDataWithEmptyData_WHEN_rawValue_THEN_shouldReturnEmptyData() {
        XCTAssert(
			USBMuxMessageData(
				origin: Data()
			).dataValue.isEmpty
		)
    }
    
    func test_GIVEN_USBMuxMessageDataWithInvalidData_WHEN_rawValue_THEN_shouldReturnEmptyData() {
        XCTAssert(
			USBMuxMessageData(
				origin: "Hello World! Hello World! Hello World!".data(using: .utf8)!
			).dataValue.isEmpty
		)
    }
    
    func test_GIVEN_USBMuxMessageDataWithValidData_WHEN_rawValue_THEN_shouldReturnRawData() {
		XCTAssert(
			USBMuxMessageData(
				origin: MessageData(
					data: RawData("Hello World!".data(using: .utf8)!),
					packetType: 1,
					messageTag: 2,
					protocolType: 3
				).dataValue
			).dataValue == "Hello World!".data(using: .utf8)!
		)
    }
}
