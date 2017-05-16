/**
 *
 * 	DarkLightning
 *
 *
 *
 *	The MIT License (MIT)
 *
 *	Copyright (c) 2017 Jens Meder
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy of
 *	this software and associated documentation files (the "Software"), to deal in
 *	the Software without restriction, including without limitation the rights to
 *	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *	the Software, and to permit persons to whom the Software is furnished to do so,
 *	subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in all
 *	copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 *	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 *	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 *	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 *	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

internal final class ReadStreamReaction: NSObject, StreamDelegate {
    
	// MARK: Constants
	
	private static let MaxBufferSize: UInt = 2048
	
	// MARK: Members
	
    private let delegate: DataDecoding
    private let data: UnsafeMutablePointer<UInt8>
    private let bufferSize: UInt
	
	// MARK: Init
	
	internal convenience init(delegate: DataDecoding) {
		self.init(
			bufferSize: ReadStreamReaction.MaxBufferSize,
			delegate: delegate
		)
	}
	
    internal convenience init(bufferSize: UInt, delegate: DataDecoding) {
        self.init(
            bufferSize: ReadStreamReaction.MaxBufferSize,
            data: UnsafeMutablePointer<UInt8>.allocate(capacity: Int(bufferSize)),
            delegate: delegate
        )
	}
	
    internal required init(bufferSize: UInt, data: UnsafeMutablePointer<UInt8>, delegate: DataDecoding) {
        self.bufferSize = bufferSize;
        self.data = data
        self.delegate = delegate
    }
    
    // MARK: - Private
    
    deinit {
        data.deallocate(capacity: Int(bufferSize))
    }
    
    // MARK: StreamDelegate
	
	func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        if eventCode == .hasBytesAvailable {
			var buffer = Data()
			let inputStream = aStream as! InputStream
			while inputStream.hasBytesAvailable {
                data.initialize(to: 0)
				let length = inputStream.read(data, maxLength: Int(bufferSize))
				if length > 0 {
					buffer.append(data, count: length)
				}
			}
            if !buffer.isEmpty {
                delegate.decode(data: RawData(buffer))
            }
		}
	}
}
