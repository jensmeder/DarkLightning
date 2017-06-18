//
//  TCPModeSpec.swift
//  Tests
//
//  Created by Jens Meder on 18.06.17.
//

import XCTest
@testable import DarkLightning

class TCPModeSpec: XCTestCase {
    
	func test_GIVEN_TCPMode_WHEN_boolValue_AND_valueIsTrue_THEN_tcpModeShouldBeTrue() {
		let tcpMode = Memory<Bool>(initialValue: false)
		TCPMode(
			tcpMode: tcpMode,
			queue: DispatchQueue.main,
			delegate: DeviceDelegateFake(),
			device: DeviceFake()
		).boolValue = true
		XCTAssertTrue(
			tcpMode.rawValue
		)
	}
	
	func test_GIVEN_TCPMode_WHEN_boolValue_AND_valueIsFalse_THEN_tcpModeShouldBeTrue() {
		let tcpMode = Memory<Bool>(initialValue: false)
		TCPMode(
			tcpMode: tcpMode,
			queue: DispatchQueue.main,
			delegate: DeviceDelegateFake(),
			device: DeviceFake()
			).boolValue = false
		XCTAssertFalse(
			tcpMode.rawValue
		)
	}
    
}
