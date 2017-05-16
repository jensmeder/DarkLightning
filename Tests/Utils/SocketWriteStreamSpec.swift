//
//  SocketWriteStreamSpec.swift
//  DarkLightning
//
//  Created by Jens Meder on 15.05.17.
//
//

import XCTest
@testable import DarkLightning

class SocketWriteStreamSpec: XCTestCase {
    
    func test_GIVEN_SocketWriteStream_WHEN_write_AND_dataIsEmpty_THEN_shouldNotSendData() {
        // GIVEN
        let outputStream = OutputStream(toMemory: ())
        let writeStream = SocketWriteStream(outputStream: Memory<OutputStream?>(initialValue: outputStream))
        outputStream.open()
        
        // WHEN
        writeStream.write(data: Data())
        let result:Data = outputStream.property(forKey: .dataWrittenToMemoryStreamKey) as! Data
        
        // THEN
        XCTAssert(result.isEmpty)
    }
    
    func test_GIVEN_SocketWriteStream_WHEN_write_THEN_shouldSendData() {
        // GIVEN
        let data = "Hello World".data(using: .utf8)!
        let outputStream = OutputStream(toMemory: ())
        let writeStream = SocketWriteStream(outputStream: Memory<OutputStream?>(initialValue: outputStream))
        outputStream.open()
        
        // WHEN
        writeStream.write(data: data)
        let result:Data = outputStream.property(forKey: .dataWrittenToMemoryStreamKey) as! Data
        
        // THEN
        XCTAssert(result == data)
    }
    
}
