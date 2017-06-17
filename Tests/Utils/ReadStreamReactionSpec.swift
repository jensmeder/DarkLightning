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
        let stream = InputStream(data: "Hello World!".data(using: .utf8)!)
        stream.open()
        let delegate = DataDecodingFake()
        ReadStreamReaction(delegate: delegate).stream(stream, handle: .hasBytesAvailable)
        XCTAssert("Hello World!".data(using: .utf8)! == delegate.data!.rawValue)
    }
    
}
