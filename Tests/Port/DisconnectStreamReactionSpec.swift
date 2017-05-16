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
        // GIVEN
        let delegate = PortDelegateFake()
        let port = PortFake()
        let stream = OutputStream(toMemory: ())
        let reaction = DisconnectStreamReaction(delegate: delegate, port: port)
        
        // WHEN
        reaction.stream(stream, handle: .endEncountered)
        
        // THEN
        XCTAssert(port.isEqual(obj: delegate.port!))
    }
    
}
