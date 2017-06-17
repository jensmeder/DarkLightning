//
//  USBDeviceSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class USBDeviceSpec: XCTestCase {
    
    func testUSBDeviceCompositionRoot() {
        XCTAssertNotNil(USBDevice())
    }
    
}
