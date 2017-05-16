//
//  CachedDevicesSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class CachedDevicesSpec: XCTestCase {
    
    func test_GIVEN_CachedDevicesWithoutObjects_WHEN_device_THEN_returnsEmptyArray() {
        // GIVEN
        let cache = Memory<[Int : Device]>(initialValue: [:])
        let devices = CachedDevices(origin: DevicesFake(), cache: cache)
    
        // WHEN
        let result = devices.device(withID: 0)
    
        // THEN
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_GIVEN_CachedDevicesWithObjects_WHEN_deviceWithValidId_THEN_returnsArrayWithExactlyOneObject() {
        // GIVEN
        let cache = Memory<[Int : Device]>(initialValue: [0: DeviceFake()])
        let devices = CachedDevices(origin: DevicesFake(), cache: cache)
        
        // WHEN
        let result = devices.device(withID: 0)
        
        // THEN
        XCTAssertTrue(result.count == 1)
    }
    
    func test_GIVEN_CachedDevicesWithObjects_WHEN_deviceWithValidId_THEN_returnsArrayWithObject() {
        // GIVEN
        let device = DeviceFake()
        let cache = Memory<[Int : Device]>(initialValue: [0:device])
        let devices = CachedDevices(origin: DevicesFake(), cache: cache)
        
        // WHEN
        let result = devices.device(withID: 0)
        
        // THEN
        XCTAssertTrue(result.first!.isEqual(obj: device))
    }
    
    func test_GIVEN_CachedDevices_WHEN_insert_THEN_cacheShouldContainNewObject() {
        // GIVEN
        let cache = Memory<[Int : Device]>(initialValue: [:])
        let devices = CachedDevices(origin: MemoryDevices(), cache: cache)
        
        // WHEN
        devices.insert(deviceID: 0, data: "Hello".data(using: .utf8)!)
        
        // THEN
        XCTAssertNotNil(cache.rawValue[0])
    }
    
    func test_GIVEN_CachedDevices_WHEN_delete_AND_deviceIDDoesNotExist_THEN_cacheShouldNotChange() {
        // GIVEN
        let cache = Memory<[Int : Device]>(initialValue: [:])
        let devices = CachedDevices(origin: MemoryDevices(), cache: cache)
        
        // WHEN
        devices.delete(withID: 0)
        
        // THEN
        XCTAssertTrue(cache.rawValue.count == 0)
    }
    
    func test_GIVEN_CachedDevices_WHEN_delete_AND_deviceIDExists_THEN_deviceShouldBeRemovedFromCache() {
        // GIVEN
        let cache = Memory<[Int : Device]>(initialValue: [0:DeviceFake()])
        let devices = CachedDevices(origin: MemoryDevices(devices: Memory<[Int : Data]>(initialValue: [0:Data()]), closure: { (deviceID: Int, devices: Devices) -> (Device) in
            return DeviceFake()
        }), cache: cache)
        
        // WHEN
        devices.delete(withID: 0)
        
        // THEN
        XCTAssertTrue(cache.rawValue.count == 0)
    }
    
    func test_GIVEN_CachedDevices_WHEN_delete_AND_deviceIDExists_THEN_deviceShouldBeRemovedFromOrigin() {
        // GIVEN
        let cache = Memory<[Int : Device]>(initialValue: [0:DeviceFake()])
        let deviceList = Memory<[Int : Data]>(initialValue: [0:Data()])
        let devices = CachedDevices(origin: MemoryDevices(devices: deviceList, closure: { (deviceID: Int, devices: Devices) -> (Device) in
            return DeviceFake()
        }), cache: cache)
        
        // WHEN
        devices.delete(withID: 0)
        
        // THEN
        XCTAssertTrue(deviceList.rawValue.count == 0)
    }
}
