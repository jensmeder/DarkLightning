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
        // GIVEN
        let plist: [String: Any] = ["MessageType": "Attached", "DeviceID": 0, "Properties": [:]]
        let cache = Memory<[Int : Data]>(initialValue: [:])
        let devices = MemoryDevices(devices: cache) { (deviceID: Int, deviceList: Devices) -> (Device) in
            return DeviceFake()
        }
        let message = AttachMessage(plist: plist, devices: devices)
        
        // WHEN
        message.decode()
        
        // THEN
        XCTAssertNotNil(cache.rawValue[0])
    }
    
    func test_GIVEN_AttachMessageWithEmptyPList_WHEN_decode_THEN_shouldRedirectToOrigin() {
        // GIVEN
        let plist: [String: Any] = [:]
        let cache = Memory<[Int : Data]>(initialValue: [:])
        let devices = MemoryDevices(devices: cache) { (deviceID: Int, deviceList: Devices) -> (Device) in
            return DeviceFake()
        }
        let origin = USBMuxMessageFake()
        let message = AttachMessage(origin: origin, plist: plist, devices: devices)
        
        // WHEN
        message.decode()
        
        // THEN
        XCTAssertTrue(origin.shouldDecode)
    }
    
    func test_GIVEN_AttachMessageWithInvalidPList_WHEN_decode_THEN_shouldRedirectToOrigin() {
        // GIVEN
        let plist: [String: Any] = ["MessageType":"Attached", "DeviceID": ""]
        let cache = Memory<[Int : Data]>(initialValue: [:])
        let devices = MemoryDevices(devices: cache) { (deviceID: Int, deviceList: Devices) -> (Device) in
            return DeviceFake()
        }
        let origin = USBMuxMessageFake()
        let message = AttachMessage(origin: origin, plist: plist, devices: devices)
        
        // WHEN
        message.decode()
        
        // THEN
        XCTAssertTrue(origin.shouldDecode)
    }
    
}
