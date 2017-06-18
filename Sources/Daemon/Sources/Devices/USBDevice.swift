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

internal final class USBDevice: DeviceWrap {
    private let deviceID: Int
    
    internal convenience init() {
        self.init(
            devices: DevicesFake(),
            deviceID: 0,
            dictionary: Memory<[Int : Data]>(initialValue: [:]),
            port: 1234,
            delegate: DeviceDelegateFake()
        )
    }
    
    internal convenience init(devices: Devices, deviceID: Int, dictionary: Memory<[Int: Data]>, port: UInt32, delegate: DeviceDelegate) {
        let handle = Memory<CFSocketNativeHandle>(initialValue: CFSocketInvalidHandle)
        let state = Memory<Int>(initialValue: 0)
        let inputStream = Memory<InputStream?>(initialValue: nil)
        let outputStream = Memory<OutputStream?>(initialValue: nil)
        let tcpMode = Memory<Bool>(initialValue: false)
		let queue = DispatchQueue.global(qos: .background)
        let root = Memory<Daemon?>(initialValue: nil)
        self.init(
            deviceID: deviceID,
            dictionary: dictionary,
            daemon: USBDaemon(
                socket: handle,
                queue: queue,
                stream: SocketStream(
                    handle: handle,
                    inputStream: inputStream,
                    outputStream: outputStream,
                    readReaction: StreamDelegates(
                        delegates: [
                            ReadStreamReaction(
                                delegate: DataDecodings(
									decodings: [
										TCPMessage(
											tcpMode: tcpMode,
											delegate: delegate,
											devices: devices,
											deviceID: deviceID
										),
										ReceivingDataReaction(
											tcpMode: tcpMode,
											mapping: { (plist: [String : Any]) -> (USBMuxMessage) in
												return ResultMessage(
													plist: plist,
													devices: devices,
													deviceID: deviceID,
													tcpMode: { (device) -> (BoolValue) in
														return TCPMode(
															tcpMode: tcpMode,
															queue: DispatchQueue.main,
															delegate: delegate,
															device: device
														)
													}
												)
											},
											dataMapping: { (data: Data) -> (OODataArray) in
												return USBMuxMessageDataArray(
													data: data
												)
											}
										)
									]
								)
                            ),
                            EndOfStreamReaction(
                                origin: StreamDelegates(
                                    delegates: [
                                        NotifyDisconnectReaction(
                                            delegate: delegate,
                                            deviceID: deviceID,
                                            devices: devices
                                        ),
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
                                message: ConnectMessageData(
                                    deviceID: deviceID,
                                    port: port
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
            ),
            stream: SocketWriteStream(
                outputStream: outputStream
            ),
            delegate: delegate
        )
    }
    
    internal required init(deviceID: Int, dictionary: Memory<[Int: Data]>, daemon: Daemon, stream: WriteStream, delegate: DeviceDelegate) {
        self.deviceID = deviceID
        super.init(
            origin: USBDeviceConnection(
                deviceID: deviceID,
                dictionary: dictionary,
                daemon: daemon,
                stream: stream,
                delegate: delegate
            )
        )
    }
    
    override func isEqual(obj: Any) -> Bool {
        var result = false
        if let device = obj as? USBDevice {
            result = device.deviceID == deviceID
        }
        return result
    }
}
