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
        XCTAssertTrue(
			CachedDevices(
				origin: DevicesFake(),
				cache: Memory<[Int : Device]>(
					initialValue: [:]
				)
			).device(
				withID: 0
			).isEmpty
		)
    }
    
    func test_GIVEN_CachedDevicesWithObjects_WHEN_deviceWithValidId_THEN_returnsArrayWithExactlyOneObject() {
        XCTAssertTrue(
			CachedDevices(
				origin: DevicesFake(),
				cache: Memory<[Int : Device]>(
					initialValue: [0: DeviceFake()]
				)
			).device(
				withID: 0
			).count == 1
		)
    }
    
    func test_GIVEN_CachedDevicesWithObjects_WHEN_deviceWithValidId_THEN_returnsArrayWithObject() {
        XCTAssertTrue(
			CachedDevices(
				origin: DevicesFake(),
				cache: Memory<[Int : Device]>(
					initialValue: [0:DeviceFake()]
				)
			).device(
				withID: 0
			).first!.isEqual(
				obj: DeviceFake()
			)
		)
    }
    
    func test_GIVEN_CachedDevices_WHEN_insert_THEN_cacheShouldContainNewObject() {
        let cache = Memory<[Int : Device]>(initialValue: [:])
        CachedDevices(
			origin: MemoryDevices(),
			cache: cache
		).insert(
			deviceID: 0,
			data: "Hello".data(
				using: .utf8
			)!
		)
        XCTAssertNotNil(cache.rawValue[0])
    }
    
    func test_GIVEN_CachedDevices_WHEN_delete_AND_deviceIDDoesNotExist_THEN_cacheShouldNotChange() {
        let cache = Memory<[Int : Device]>(initialValue: [:])
        CachedDevices(
			origin: MemoryDevices(),
			cache: cache
		).delete(
			withID: 0
		)
        XCTAssertTrue(cache.rawValue.count == 0)
    }
    
    func test_GIVEN_CachedDevices_WHEN_delete_AND_deviceIDExists_THEN_deviceShouldBeRemovedFromCache() {
        let cache = Memory<[Int : Device]>(initialValue: [0:DeviceFake()])
		CachedDevices(
			origin: MemoryDevices(
				devices: Memory<[Int : Data]>(
					initialValue: [0:Data()]
				)
			),
			cache: cache
		).delete(
			withID: 0
		)
        XCTAssertTrue(cache.rawValue.count == 0)
    }
    
    func test_GIVEN_CachedDevices_WHEN_delete_AND_deviceIDExists_THEN_deviceShouldBeRemovedFromOrigin() {
        let deviceList = Memory<[Int : Data]>(initialValue: [0:Data()])
		CachedDevices(
			origin: MemoryDevices(
				devices: deviceList
			),
			cache: Memory<[Int : Device]>(
				initialValue: [0:DeviceFake()]
			)
		).delete(
			withID: 0
		)
        XCTAssertTrue(deviceList.rawValue.count == 0)
    }
}
