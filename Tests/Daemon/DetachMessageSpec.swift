//
//  DetachMessageSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 17.06.17.
//
//

import XCTest
@testable import DarkLightning

class DetachMessageSpec: XCTestCase {
	
	func test_GIVEN_DetachMessageWithValidPList_WHEN_decode_THEN_shouldDeleteDevice() {
		let cache = Memory<[Int : Data]>(initialValue: [0:Data()])
		DetachMessage(
			plist: [
				"MessageType": "Detached",
				"DeviceID": 0
			],
			devices: MemoryDevices(
				devices: cache
			)
		).decode()
		XCTAssertTrue(cache.rawValue.isEmpty)
	}
	
}
