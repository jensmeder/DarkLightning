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
		XCTAssertTrue(
			MemoryDevices().device(withID: 0).isEmpty
		)
    }
    
    func test_GIVEN_MemoryDevicesWithObjects_WHEN_deviceWithValidId_THEN_returnsArrayWithExactlyOneObject() {
		XCTAssertTrue(
			MemoryDevices(
				devices: Memory<[Int : Data]>(
					initialValue: [0:Data()]
				)
			).device(
				withID: 0
			).count == 1
		)
    }
    
    func test_GIVEN_MemoryDevicesWithObjects_WHEN_deviceWithValidId_THEN_returnsArrayWithObject() {
		XCTAssertTrue(
			MemoryDevices(
				devices: Memory<[Int : Data]>(
					initialValue: [0:Data()]
				)
			).device(
				withID: 0
			).first!.isEqual(
				obj: DeviceFake()
			)
		)
    }
    
    func test_GIVEN_MemoryDevices_WHEN_insert_THEN_cacheShouldContainNewObject() {
        let cache = Memory<[Int : Data]>(initialValue: [:])
        MemoryDevices(
			devices: cache
		).insert(
			deviceID: 0,
			data: "Hello".data(using: .utf8)!
		)
        XCTAssertNotNil(cache.rawValue[0])
    }
    
    func test_GIVEN_MemoryDevices_WHEN_delete_AND_deviceIDDoesNotExist_THEN_cacheShouldNotChange() {
        let cache = Memory<[Int : Data]>(initialValue: [:])
        MemoryDevices(
			devices: cache
		).delete(
			withID: 0
		)
        XCTAssertTrue(cache.rawValue.count == 0)
    }
    
    func test_GIVEN_MemoryDevices_WHEN_delete_AND_deviceIDExists_THEN_deviceShouldBeRemovedFromCache() {
        let cache = Memory<[Int : Data]>(initialValue: [0:Data()])
        MemoryDevices(
			devices: cache
		).delete(
			withID: 0
		)
        XCTAssertTrue(cache.rawValue.count == 0)
    }
    
}
