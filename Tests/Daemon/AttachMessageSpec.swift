//
//  AttachMessageSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 16.05.17.
//
//

import XCTest
@testable import DarkLightning

class AttachMessageSpec: XCTestCase {
    
    func test_GIVEN_AttachMessageWithValidPList_WHEN_decode_THEN_shouldInsertDevice() {
        let cache = Memory<[Int : Data]>(initialValue: [:])
		AttachMessage(
			plist: [
				"MessageType": "Attached",
				"DeviceID": 0,
				"Properties": [:]
			],
			devices: MemoryDevices(
				devices: cache
			)
		).decode()
        XCTAssertNotNil(cache.rawValue[0])
    }
    
}
