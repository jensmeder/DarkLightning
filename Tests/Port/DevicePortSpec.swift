//
//  DevicePortSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class DevicePortSpec: XCTestCase {
    
    func testDevicePortCompositionRoot() {
        let port = DevicePort()
        XCTAssertNotNil(port)
    }
    
}
