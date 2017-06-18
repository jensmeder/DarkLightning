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

public final class USBDaemon: DaemonWrap {
	
    // MARK: Constants
    
    private static let DefaultPort: UInt32 = 2347
    
	// MARK: Init
	
	public convenience init() {
        self.init(
            delegate: DaemonDelegateFake(),
            deviceDelegate:DeviceDelegateFake()
        )
	}
    
    public convenience init(delegate: DaemonDelegate, deviceDelegate: DeviceDelegate) {
        self.init(
            delegate: delegate,
            deviceDelegate: deviceDelegate,
            port: USBDaemon.DefaultPort
        )
    }
	
    public convenience init(delegate: DaemonDelegate, deviceDelegate: DeviceDelegate, port: UInt32) {
        let handle = Memory<CFSocketNativeHandle>(initialValue: CFSocketInvalidHandle)
        let state = Memory<Int>(initialValue: 0)
		let devices = Memory<[Int: Data]>(initialValue: [:])
		let cache = Memory<[Int: Device]>(initialValue: [:])
        let inputStream = Memory<InputStream?>(initialValue: nil)
        let outputStream = Memory<OutputStream?>(initialValue: nil)
        let root = Memory<Daemon?>(initialValue: nil)
        let deviceList = NotifyingDevices(
            origin: CachedDevices(
                origin: MemoryDevices(
                    devices: devices,
                    closure: { (deviceID: Int, deviceList: Devices) -> (Device) in
                        return USBDevice(
                            devices: CachedDevices(
                                origin: deviceList,
                                cache: cache
                            ),
                            deviceID: deviceID,
                            dictionary: devices,
                            port: port,
                            delegate: deviceDelegate
                        )
                    }
                ),
                cache: cache
            ),
            delegate: delegate,
            daemon: root
        )
		self.init(
			socket: handle,
			queue: DispatchQueue.global(qos: .background),
			stream: SocketStream(
                handle: handle,
                inputStream: inputStream,
                outputStream: outputStream,
                readReaction: StreamDelegates(
                    delegates: [
                        ReadStreamReaction(
                            delegate: ReceivingDataReaction(
								mapping: { (plist: [String : Any]) -> (USBMuxMessage) in
                                    return IncomingMessages(
										messages: [
											AttachMessage(
												plist: plist,
												devices: deviceList
											),
											DetachMessage(
												plist: plist,
												devices: deviceList
											)
										]
									)
                                },
                                dataMapping: { (data: Data) -> (OODataArray) in
                                    return USBMuxMessageDataArray(
                                        data: data
                                    )
                                }
                            )
                        ),
                        EndOfStreamReaction(
                            origin: StreamDelegates(
                                delegates: [
                                    CloseStreamReaction(),
                                    DisconnectReaction(
                                        handle: handle,
                                        state: state,
                                        newState: 0
                                    )
                                ]
                            )
                        )                        
                    ]
                ),
                writeReaction: StreamDelegates(
                    delegates: [
                        OpenReaction(
                            state: state,
                            outputStream: SocketWriteStream(
                                outputStream: outputStream
                            ),
                            newState: 1
                        ),
                        EndOfStreamReaction(
                            origin: CloseStreamReaction()
                        ),
                    ]
                )
            ),
			root: root,
			state: state
		)
	}
    
    public required init(socket: Memory<CFSocketNativeHandle>, queue: DispatchQueue, stream: DataStream, root: Memory<Daemon?>, state: Memory<Int>) {
        super.init(
            origin: USBDaemonSocket(
                socket: socket,
                queue: queue,
                stream: stream,
                state: state,
                newState: 0
            )
        )
        weak var weakSelf = self
        root.rawValue = weakSelf
    }
}
