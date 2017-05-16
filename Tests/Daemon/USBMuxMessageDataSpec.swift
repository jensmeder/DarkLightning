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
        // GIVEN
        let data = USBMuxMessageData(origin: Data())
        
        // WHEN
        let result = data.rawValue
        
        // THEN
        XCTAssert(result.isEmpty)
    }
    
    func test_GIVEN_USBMuxMessageDataWithInvalidData_WHEN_rawValue_THEN_shouldReturnEmptyData() {
        // GIVEN
        let data = USBMuxMessageData(origin: "Hello World! Hello World! Hello World!".data(using: .utf8)!)
        
        // WHEN
        let result = data.rawValue
        
        // THEN
        XCTAssert(result.isEmpty)
    }
    
    func test_GIVEN_USBMuxMessageDataWithValidData_WHEN_rawValue_THEN_shouldReturnRawData() {
        // GIVEN
        let rawData = "Hello World!".data(using: .utf8)!
        let origin = MessageData(data: RawData(rawData), packetType: 1, messageTag: 2, protocolType: 3)
        let data = USBMuxMessageData(origin: origin.rawValue)
        
        // WHEN
        let result = data.rawValue
        
        // THEN
        XCTAssert(result == rawData)
    }
}
