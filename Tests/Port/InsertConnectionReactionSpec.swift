//
//  InsertConnectionReactionSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class InsertConnectionReactionSpec: XCTestCase {
    
    func test_GIVEN_InsertConnectionReaction_WHEN_insert_THEN_informsDelegate() {
        let delegate = PortDelegateFake()
        InsertConnectionReaction(
			origin: ConnectionsFake(),
			delegate: delegate,
			port: PortFake()
		).insert(
			address: Data(),
			socket: CFSocketInvalidHandle
		)
        XCTAssert(
			delegate.port!.isEqual(obj: PortFake())
		)
    }

}
