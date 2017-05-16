//
//  StreamDelegatesSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class StreamDelegatesSpec: XCTestCase {
    
    func test_GIVEN_StreamDelegates_WHEN_stream_THEN_shouldCallStreamOnEachDelegateThatImplementsCallback() {
        // GIVEN
        let stream = OutputStream(toMemory: ())
        let delegate = StreamDelegateFake()
        let delegates = StreamDelegates(
            delegates: [
                delegate
            ]
        )
    
        // WHEN
        delegates.stream(stream, handle: .errorOccurred)
    
        // THEN
        XCTAssert(delegate.stream == stream)
    }
    
}
