//
//  IncomingDataReactionSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class IncomingDataReactionSpec: XCTestCase {
    
    func test_GIVEN_IncomingDataReaction_WHEN_decode_THEN_informsDelegate() {
        let delegate = PortDelegateFake()
        IncomingDataReaction(
			port: PortFake(),
			delegate: delegate
		).decode(
			data: OODataFake()
		)
        XCTAssert(delegate.port!.isEqual(obj: PortFake()))
    }
    
}
