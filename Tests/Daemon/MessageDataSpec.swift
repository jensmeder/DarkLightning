//
//  MessageDataSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class MessageDataSpec: XCTestCase {
    
    func test_GIVEN_MessageData_WHEN_rawValue_THEN_shouldReturnEncodedData() {
        // GIVEN
        let data = MessageData(data: OODataFake(), packetType: 1, messageTag: 2, protocolType: 3)
        
        // WHEN
        let result = data.rawValue
        
        // THEN
        XCTAssert(result.count > 0)
    }
    
}
