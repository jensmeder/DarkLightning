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
        // GIVEN
        let plist: [String: Any] = ["MessageType": "Result", "Number": 0]
        let cache = Memory<[Int : Data]>(initialValue: [0:Data()])
        let devices = MemoryDevices(devices: cache) { (deviceID: Int, deviceList: Devices) -> (Device) in
            return DeviceFake()
        }
        let tcpMode = Memory<Bool>(initialValue: false)
        let message = ResultMessage(plist: plist, tcpMode: tcpMode, delegate: DeviceDelegateFake(), devices: devices, deviceID: 0)
        
        // WHEN
        message.decode()
        
        // THEN
        XCTAssertTrue(tcpMode.rawValue)
    }
    
    func test_GIVEN_ResultMessageWithValidPList_AND_resultIsNegative_WHEN_decode_THEN_shouldExitTCPMode() {
        // GIVEN
        let plist: [String: Any] = ["MessageType": "Result", "Number": 1]
        let cache = Memory<[Int : Data]>(initialValue: [0:Data()])
        let devices = MemoryDevices(devices: cache) { (deviceID: Int, deviceList: Devices) -> (Device) in
            return DeviceFake()
        }
        let tcpMode = Memory<Bool>(initialValue: true)
        let message = ResultMessage(plist: plist, tcpMode: tcpMode, delegate: DeviceDelegateFake(), devices: devices, deviceID: 0)
        
        // WHEN
        message.decode()
        
        // THEN
        XCTAssertFalse(tcpMode.rawValue)
    }
    
}
