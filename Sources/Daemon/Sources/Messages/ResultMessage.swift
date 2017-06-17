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

internal final class ResultMessage: USBMuxMessage {
	
	// MARK: Constants
	
	private static let MessageTypeResult = "Result"
	private static let MessageTypeKey = "MessageType"
    private static let NumberKey = "Number"
    private static let ResultOK = 0
	
	// MARK: Members
	
	private let plist: [String: Any]
    private let tcpMode: Memory<Bool>
    private let delegate: DeviceDelegate
	private let devices: Devices
	private let deviceID: Int
    private let queue: DispatchQueue
	
	// MARK: Init
	
	internal convenience init(plist: [String: Any], tcpMode: Memory<Bool>, devices: Devices, deviceID: Int) {
		self.init(
			plist: plist,
			tcpMode: tcpMode,
			delegate: DeviceDelegateFake(),
			devices: devices,
			deviceID: deviceID,
			queue: DispatchQueue.main
		)
	}
    
    internal convenience init(plist: [String: Any], tcpMode: Memory<Bool>, delegate: DeviceDelegate, devices: Devices, deviceID: Int) {
        self.init(
            plist: plist,
            tcpMode: tcpMode,
            delegate: delegate,
            devices: devices,
            deviceID: deviceID,
            queue: DispatchQueue.main
        )
    }
    
    internal required init(plist: [String: Any], tcpMode: Memory<Bool>, delegate: DeviceDelegate, devices: Devices, deviceID: Int, queue: DispatchQueue) {
		self.plist = plist
        self.tcpMode = tcpMode
        self.delegate = delegate
		self.devices = devices
		self.deviceID = deviceID
        self.queue = queue
	}
	
	// MARK: USBMuxMessage
	
	func decode() {
		if let messageType = plist[ResultMessage.MessageTypeKey] as? String, messageType == ResultMessage.MessageTypeResult {
            if let device = devices.device(withID: deviceID).first, let number = plist[ResultMessage.NumberKey] as? Int {
                if number == ResultMessage.ResultOK {
                    tcpMode.rawValue = true
                    queue.async {
                        self.delegate.device(didConnect: device)
                    }
                }
                else {
                    tcpMode.rawValue = false
                    queue.async {
                        self.delegate.device(didFailToConnect: device)
                    }
                    device.disconnect()
                }
            }
		}
	}
}
