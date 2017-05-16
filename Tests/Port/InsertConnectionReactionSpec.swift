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
        // GIVEN
        let delegate = PortDelegateFake()
        let port = PortFake()
        let reaction = InsertConnectionReaction(origin: ConnectionsFake(), delegate: delegate, port: port)
        
        // WHEN
        reaction.insert(address: Data(), socket: CFSocketInvalidHandle)
        
        // THEN
        XCTAssert(port.isEqual(obj: delegate.port!))
    }

}
