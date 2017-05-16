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
        // GIVEN
        let delegate = PortDelegateFake()
        let port = PortFake()
        let reaction = IncomingDataReaction(port: port, delegate: delegate)

        // WHEN
        reaction.decode(data: OODataFake())
        
        // THEN
        XCTAssert(port.isEqual(obj: delegate.port!))
    }
    
}
