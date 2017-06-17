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
        let stream = OutputStream(toMemory: ())
        let delegate = StreamDelegateFake()
		StreamDelegates(
			delegates: [
				delegate
			]
		).stream(
			stream,
			handle: .errorOccurred
		)
        XCTAssert(delegate.stream == stream)
    }
    
}
