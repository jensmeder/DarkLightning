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
    private let tcpMode: (Device) -> (BoolValue)
	private let devices: Devices
	private let deviceID: Int
	
	// MARK: Init
    
	internal required init(plist: [String: Any], devices: Devices, deviceID: Int, tcpMode: @escaping (Device) -> (BoolValue)) {
		self.plist = plist
        self.tcpMode = tcpMode
		self.devices = devices
		self.deviceID = deviceID
	}
	
	// MARK: USBMuxMessage
	
	func decode() {
		if let messageType = plist[ResultMessage.MessageTypeKey] as? String, messageType == ResultMessage.MessageTypeResult {
            if let device = devices.device(withID: deviceID).first, let number = plist[ResultMessage.NumberKey] as? Int {
				let mode = tcpMode(device)
                if number == ResultMessage.ResultOK {
                    mode.boolValue = true
                }
                else {
                    mode.boolValue = false
                    device.disconnect()
                }
            }
		}
	}
}
