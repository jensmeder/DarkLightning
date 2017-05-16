//
//  MemoryDevicesSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class MemoryDevicesSpec: XCTestCase {
    
    func test_GIVEN_MemoryDevicesWithoutObjects_WHEN_device_THEN_returnsEmptyArray() {
        // GIVEN
        let cache = Memory<[Int : Data]>(initialValue: [:])
        let devices = MemoryDevices(devices: cache) { (deviceID: Int, devices: Devices) -> (Device) in
            return DeviceFake()
        }
        
        // WHEN
        let result = devices.device(withID: 0)
        
        // THEN
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_GIVEN_MemoryDevicesWithObjects_WHEN_deviceWithValidId_THEN_returnsArrayWithExactlyOneObject() {
        // GIVEN
        let cache = Memory<[Int : Data]>(initialValue: [0:Data()])
        let devices = MemoryDevices(devices: cache) { (deviceID: Int, devices: Devices) -> (Device) in
            return DeviceFake()
        }
        
        // WHEN
        let result = devices.device(withID: 0)
        
        // THEN
        XCTAssertTrue(result.count == 1)
    }
    
    func test_GIVEN_MemoryDevicesWithObjects_WHEN_deviceWithValidId_THEN_returnsArrayWithObject() {
        // GIVEN
        let cache = Memory<[Int : Data]>(initialValue: [0:Data()])
        let device = DeviceFake()
        let devices = MemoryDevices(devices: cache) { (deviceID: Int, devices: Devices) -> (Device) in
            return device
        }
        
        // WHEN
        let result = devices.device(withID: 0)
        
        // THEN
        XCTAssertTrue(result.first!.isEqual(obj: device))
    }
    
    func test_GIVEN_MemoryDevices_WHEN_insert_THEN_cacheShouldContainNewObject() {
        // GIVEN
        let cache = Memory<[Int : Data]>(initialValue: [:])
        let devices = MemoryDevices(devices: cache) { (deviceID: Int, devices: Devices) -> (Device) in
            return DeviceFake()
        }
        
        // WHEN
        devices.insert(deviceID: 0, data: "Hello".data(using: .utf8)!)
        
        // THEN
        XCTAssertNotNil(cache.rawValue[0])
    }
    
    func test_GIVEN_MemoryDevices_WHEN_delete_AND_deviceIDDoesNotExist_THEN_cacheShouldNotChange() {
        // GIVEN
        let cache = Memory<[Int : Data]>(initialValue: [:])
        let devices = MemoryDevices(devices: cache) { (deviceID: Int, devices: Devices) -> (Device) in
            return DeviceFake()
        }
        
        // WHEN
        devices.delete(withID: 0)
        
        // THEN
        XCTAssertTrue(cache.rawValue.count == 0)
    }
    
    func test_GIVEN_MemoryDevices_WHEN_delete_AND_deviceIDExists_THEN_deviceShouldBeRemovedFromCache() {
        // GIVEN
        let cache = Memory<[Int : Data]>(initialValue: [0:Data()])
        let device = DeviceFake()
        let devices = MemoryDevices(devices: cache) { (deviceID: Int, devices: Devices) -> (Device) in
            return device
        }
        
        // WHEN
        devices.delete(withID: 0)
        
        // THEN
        XCTAssertTrue(cache.rawValue.count == 0)
    }
    
}
