//
//  DisconnectStreamReactionSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class DisconnectStreamReactionSpec: XCTestCase {
    
    func test_GIVEN_DisconnectStreamReaction_WHEN_stream_THEN_informsDelegate() {
		let delegate = PortDelegateFake()
		DisconnectStreamReaction(
			delegate: delegate,
			port: PortFake()
		).stream(
			OutputStream(
				toMemory: ()
			),
			handle: .endEncountered
		)
		XCTAssert(
			delegate.port!.isEqual(
				obj: PortFake()
			)
		)
    }
    
}
