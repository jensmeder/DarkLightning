//
//  ResultMessageSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 16.05.17.
//
//

import XCTest
@testable import DarkLightning

class ResultMessageSpec: XCTestCase {
    
    func test_GIVEN_ResultMessageWithValidPList_AND_resultIsPositive_WHEN_decode_THEN_shouldSwitchToTCPMode() {
        let tcpMode = Memory<Bool>(initialValue: false)
        ResultMessage(
			plist: [
				"MessageType": "Result",
				"Number": 0
			],
			devices: MemoryDevices(
				devices: Memory<[Int : Data]>(
					initialValue: [0:Data()]
				)
			),
			deviceID: 0,
			tcpMode: {(device) -> (BoolValue) in
				return TCPMode(
					tcpMode: tcpMode,
					queue: DispatchQueue.main,
					delegate: DeviceDelegateFake(),
					device: DeviceFake()
				)
			}
		).decode()
        XCTAssertTrue(tcpMode.rawValue)
    }
    
    func test_GIVEN_ResultMessageWithValidPList_AND_resultIsNegative_WHEN_decode_THEN_shouldExitTCPMode() {
        let tcpMode = Memory<Bool>(initialValue: true)
        ResultMessage(
			plist: [
				"MessageType": "Result",
				"Number": 1
			],
			devices: MemoryDevices(
				devices: Memory<[Int : Data]>(
					initialValue: [0:Data()]
				)
			),
			deviceID: 0,
			tcpMode: {(device) -> (BoolValue) in
				return TCPMode(
					tcpMode: tcpMode,
					queue: DispatchQueue.main,
					delegate: DeviceDelegateFake(),
					device: DeviceFake()
				)
		}
		).decode()
        XCTAssertFalse(tcpMode.rawValue)
    }
    
}
