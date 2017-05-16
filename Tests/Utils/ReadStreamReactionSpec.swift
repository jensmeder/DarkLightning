//
//  ReadStreamReactionSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class ReadStreamReactionSpec: XCTestCase {
    
    func test_GIVEN_ReadStreamReaction_WHEN_stream_AND_hasBytesAvailableHandle_THEN_readsDataFromStream() {
        // GIVEN
        let data = "Hello World!".data(using: .utf8)!
        let stream = InputStream(data: data)
        stream.open()
        let delegate = DataDecodingFake()
        let reaction = ReadStreamReaction(delegate: delegate)
        
        // WHEN
        reaction.stream(stream, handle: .hasBytesAvailable)
        
        // THEN
        XCTAssert(data == delegate.data!.rawValue)
    }
    
}
