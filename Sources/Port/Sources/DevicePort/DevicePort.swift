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
import CoreFoundation

public final class DevicePort: PortWrap {
	
	// MARK: Constants
	
	private static let DefaultPort: UInt16 = 2347
    
    // MARK: Members
    
    private let port: UInt16
	
	// MARK: Init
	
	public convenience init() {
		self.init(
			delegate: PortDelegateFake()
		)
	}
	
	public convenience init(delegate: PortDelegate) {
		self.init(
			port: DevicePort.DefaultPort,
			delegate: delegate
		)
	}
	
	public convenience init(port: UInt16, delegate: PortDelegate) {
        let handle = Memory<CFSocketNativeHandle>(initialValue: CFSocketInvalidHandle)
        let connectedHandle = Memory<CFSocketNativeHandle>(initialValue: CFSocketInvalidHandle)
        let queue = DispatchQueue.global(qos: .background)
        let outputStream = Memory<OutputStream?>(initialValue: nil)
        let inputStream = Memory<InputStream?>(initialValue: nil)
        let connections = SocketConnections(
            queue: queue,
            stream: SocketStream(
                handle: connectedHandle,
                inputStream: inputStream,
                outputStream: outputStream,
                readReaction: StreamDelegates(
                    delegates: [
                        ReadStreamReaction(
                            delegate: IncomingDataReaction(
								port: DevicePort(
									port: port,
									queue: queue,
									inputStream: inputStream,
									outputStream: outputStream,
									socket: handle,
									connections: SocketConnections(
										queue: queue,
										stream: SocketStream(
											handle: connectedHandle,
											inputStream: inputStream,
											outputStream: outputStream
										),
										handle: connectedHandle
									)
								),
								delegate: delegate
							)
                        ),
                        EndOfStreamReaction(
                            origin: StreamDelegates(
                                delegates: [
                                    CloseStreamReaction(),
                                    DisconnectStreamReaction(
                                        delegate: delegate,
                                        port: DevicePort(
                                            port: port,
                                            queue: queue,
                                            inputStream: inputStream,
                                            outputStream: outputStream,
                                            socket: handle,
                                            connections: SocketConnections(
                                                queue: queue,
                                                stream: SocketStream(
                                                    handle: connectedHandle,
                                                    inputStream: inputStream,
                                                    outputStream: outputStream
                                                ),
                                                handle: connectedHandle
                                            )
                                        )
                                    )
                                ]
                            )
                        )
                    ]
                ),
                writeReaction: EndOfStreamReaction(
                    origin: CloseStreamReaction()
                )
            ),
            handle: connectedHandle
        )
		self.init(
			port: port,
			queue: queue,
			inputStream: inputStream,
			outputStream: outputStream,
			socket: handle,
			connections: InsertConnectionReaction(
                origin: connections,
                delegate: delegate,
                port: DevicePort(
                    port: port,
                    queue: queue,
                    inputStream: inputStream,
                    outputStream: outputStream,
                    socket: handle,
                    connections: connections
                )
            )
		)
	}
	
    public required init(port: UInt16, queue: DispatchQueue, inputStream: Memory<InputStream?>, outputStream: Memory<OutputStream?>, socket: Memory<CFSocketNativeHandle>, connections: Connections) {
        self.port = port
		super.init(
			origin: DevicePortSocket(
                writeStream: SocketWriteStream(
                    outputStream: outputStream
                ),
                stream: SocketStream(
                    handle: Memory<CFSocketNativeHandle>(initialValue: CFSocketInvalidHandle),
                    inputStream: inputStream,
                    outputStream: outputStream
                ),
				port: port,
				queue: queue,
				connections: connections,
				socket: socket
			)
		)
    }
    
    public override func isEqual(obj: Any) -> Bool {
        var result = false
        if let port = obj as? DevicePort {
            result = port.port == self.port
        }
        return result
    }
}
