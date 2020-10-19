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

internal final class SocketStream: DataStream {
	private let readReaction: StreamDelegate
	private let writeReaction: StreamDelegate
	private let inputStream: Memory<InputStream?>
	private let outputStream: Memory<OutputStream?>
    private let handle: Memory<CFSocketNativeHandle>
	
	// MARK: Init
	
    internal convenience init(handle: Memory<CFSocketNativeHandle>, inputStream: Memory<InputStream?>, outputStream: Memory<OutputStream?>) {
        self.init(
            handle: handle,
            inputStream: inputStream,
            outputStream: outputStream,
            readReaction: StreamDelegates(),
            writeReaction: StreamDelegates()
        )
    }
    
	internal required init(handle: Memory<CFSocketNativeHandle>, inputStream: Memory<InputStream?>, outputStream: Memory<OutputStream?>, readReaction: StreamDelegate, writeReaction: StreamDelegate) {
        self.handle = handle
		self.inputStream = inputStream
		self.outputStream = outputStream
		self.readReaction = readReaction
		self.writeReaction = writeReaction
	}
    
    // MARK: DataStream
	
    func open(in queue: DispatchQueue) {
        var inputStream: Unmanaged<CFReadStream>? = nil
        var outputStream: Unmanaged<CFWriteStream>? = nil
        CFStreamCreatePairWithSocket(
            kCFAllocatorDefault,
            handle.rawValue,
            &inputStream,
            &outputStream
        )
        CFReadStreamSetProperty(
            inputStream!.takeUnretainedValue(),
            CFStreamPropertyKey(
                rawValue: kCFStreamPropertyShouldCloseNativeSocket
            ),
            kCFBooleanTrue
        )
        CFWriteStreamSetProperty(
            outputStream!.takeUnretainedValue(),
            CFStreamPropertyKey(
                rawValue: kCFStreamPropertyShouldCloseNativeSocket
            ),
            kCFBooleanTrue
        )
        self.inputStream.rawValue = inputStream!.takeRetainedValue() as InputStream
        self.outputStream.rawValue = outputStream!.takeRetainedValue() as OutputStream
        queue.sync {
            self.inputStream.rawValue?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
            self.outputStream.rawValue?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
            self.inputStream.rawValue?.delegate = self.readReaction
            self.outputStream.rawValue?.delegate = self.writeReaction
            self.inputStream.rawValue?.open()
            self.outputStream.rawValue?.open()
        }
        queue.async {
            RunLoop.current.run()
        }
	}
	
	func close() {
		if inputStream.rawValue?.streamStatus != .closed {
			inputStream.rawValue?.close()
            inputStream.rawValue = nil
		}
		if outputStream.rawValue?.streamStatus != .closed {
			outputStream.rawValue?.close()
            outputStream.rawValue = nil
		}
	}
}
